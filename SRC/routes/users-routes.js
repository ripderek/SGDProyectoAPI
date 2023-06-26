const { Router } = require('express');
const router = Router();


const { crear_usuario, datos_Usuarios } = require('../controllers/Users/users-controller');

router.post('/crear_usuario', crear_usuario);
router.get('/User/:id', datos_Usuarios);

module.exports = router;