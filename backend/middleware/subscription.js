const pool = require('../db');

async function checkPayment(req, res, next) {
  try {
    const result = await pool.query(
      'SELECT has_paid FROM users WHERE id = $1',
      [req.user.id]
    );

    if (!result.rows[0]?.has_paid) {
      return res.status(403).json({ error: 'No has realizado el pago inicial' });
    }

    next();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = checkPayment;
