const express = require('express');
const multer = require('multer');
const auth = require('../middleware/auth');
const checkPayment = require('../middleware/subscription');
const pool = require('../db');

const router = express.Router();
const upload = multer({ dest: 'uploads/' });

// Subir video (solo admin)
router.post('/upload', auth('admin'), upload.single('video'), async (req, res) => {
  const { title, description, category } = req.body;
  const videoPath = req.file.path;
  await pool.query(
    'INSERT INTO videos (title, description, category, file_path) VALUES ($1, $2, $3, $4)',
    [title, description, category, videoPath]
  );
  res.json({ message: 'Video subido correctamente' });
});

// Listar videos (requiere suscripción activa)
router.get('/', auth(), checkPayment, async (req, res) => {
  const videos = await pool.query('SELECT * FROM videos');
  res.json(videos.rows);
});

module.exports = router;
