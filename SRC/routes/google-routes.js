
const { Router } = require('express');
const router = Router();
const { verificaUserGoogle,} = require('../controllers/Auth/google-controller');



router.post('/LoginG', verificaUserGoogle);



module.exports = router;

