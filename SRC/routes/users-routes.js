const { Router } = require('express');
const router = Router();


const { crear_usuario } = require('../controllers/Users/users-controller');

router.post('/crear_usuario', crear_usuario);


module.exports = router;