const { Router } = require('express');
const router = Router();
const { verificaUser,} = require('../controllers/Auth/auth-controller')

router.post('/Login', verificaUser);

module.exports = router; 