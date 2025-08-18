const jwt = require('jsonwebtoken');
require('dotenv').config();

function auth(requiredRole = null) {
  return (req, res, next) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) return res.status(403).json({ error: 'Token requerido' });

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) return res.status(403).json({ error: 'Token inválido' });
      if (requiredRole && decoded.role !== requiredRole) {
        return res.status(403).json({ error: 'Permiso denegado' });
      }
      req.user = decoded;
      next();
    });
  };
}

module.exports = auth;
