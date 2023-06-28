const { Router } = require('express');
const router = Router();


const { crear_usuario, datos_Usuarios, all_data_users } = require('../controllers/Users/users-controller');

router.post('/crear_usuario', crear_usuario);
router.get('/User/:id', datos_Usuarios);
router.get('/Userdata', all_data_users);


module.exports = router;