const express = require('express');
const mercadopago = require('mercadopago');
const pool = require('../db');
const auth = require('../middleware/auth');
require('dotenv').config();

mercadopago.configure({
  access_token: process.env.MP_ACCESS_TOKEN
});

const router = express.Router();

// Crear preferencia de pago único
router.post('/create', auth(), async (req, res) => {
  const { plan, price } = req.body;
  const userId = req.user.id;

  try {
    const preference = {
      items: [
        { title: plan, quantity: 1, currency_id: 'ARS', unit_price: Number(price) }
      ],
      back_urls: {
        success: "https://tuweb.com/success",
        failure: "https://tuweb.com/failure",
        pending: "https://tuweb.com/pending"
      },
      auto_return: "approved",
      notification_url: "https://tu-backend.com/payments/webhook"
    };

    const response = await mercadopago.preferences.create(preference);

    // Guardar en tabla de pagos
    await pool.query(
      'INSERT INTO payments (user_id, preference_id, status) VALUES ($1, $2, $3)',
      [userId, response.body.id, 'pending']
    );

    res.json({ init_point: response.body.init_point });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Webhook de MercadoPago
router.post('/webhook', async (req, res) => {
  let paymentId;

  if (req.query.type === 'payment') {
    paymentId = req.query['data.id'];
  } else if (req.query.topic === 'payment') {
    paymentId = req.query.id;
  }

  if (!paymentId) {
    return res.sendStatus(400);
  }

  try {
    const mpPayment = await mercadopago.payment.findById(paymentId);
    const status = mpPayment.body.status;
    const preferenceId = mpPayment.body.preference_id;

    if (status === 'approved') {
      // Marcar pago como aprobado
      await pool.query(
        'UPDATE payments SET status = $1 WHERE preference_id = $2',
        ['approved', preferenceId]
      );

      // Actualizar usuario como pagado
      await pool.query(
        'UPDATE users SET has_paid = true WHERE id = (SELECT user_id FROM payments WHERE preference_id = $1)',
        [preferenceId]
      );
    }
  } catch (err) {
    console.error(err);
  }

  res.sendStatus(200);
});

// Ruta temporal para simular pago aprobado
router.post('/simulate-payment', auth(), async (req, res) => {
  try {
    await pool.query(
      'UPDATE users SET has_paid = true WHERE id = $1',
      [req.user.id]
    );
    res.json({ message: 'Pago simulado, usuario marcado como pagado' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


module.exports = router;
