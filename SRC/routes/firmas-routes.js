const { Router } = require('express');
const router = Router();

const { guardar_pdf_firma } = require('../controllers/Proyects/proyects-controller');

const { upload_firma } = require('../middleware/multer_firma');


//Para guarda el pdf con las firmas en la API
router.post('/guardar_pdf_firma', upload_firma.single('file'), guardar_pdf_firma);

module.exports = router;