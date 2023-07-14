const { Router } = require('express');
const router = Router();

const { crear_proyecto, crear_categoria, proyectos_areas, all_categorias, roles_proyecto, subir_pdf, documentos_proyectos, ver_pdf } = require('../controllers/Proyects/proyects-controller');

const { upload } = require('../middleware/multer_pdf');


//tengo que crear un trigger que inserte el codigo del proyecto 
router.post('/crear_proyecto', crear_proyecto);
router.post('/crear_categoria', crear_categoria);
router.get('/proyectos_areas/:id', proyectos_areas);
router.get('/categorias_proyecto', all_categorias);
router.post('/roles_proyecto', roles_proyecto);
router.post('/subir_pdf', upload.single('file'), subir_pdf);
router.get('/documentos_proyectos/:id', documentos_proyectos);
router.get('/pdf/:id', ver_pdf);


module.exports = router;