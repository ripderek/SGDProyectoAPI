const { Router } = require('express');
const router = Router();

const { crear_proyecto, crear_categoria, proyectos_areas, all_categorias, roles_proyecto, subir_pdf, documentos_proyectos, ver_pdf, list_categorias, editar_categoria, estado_categoria, guias_proyectos, subir_guia, download_guia } = require('../controllers/Proyects/proyects-controller');

const { upload } = require('../middleware/multer_pdf');
const { upload_guia } = require('../middleware/multer_guias');

//tengo que crear un trigger que inserte el codigo del proyecto 
router.post('/crear_proyecto', crear_proyecto);
router.post('/crear_categoria', crear_categoria);
router.post('/editar_categoria', editar_categoria);
router.post('/estado/:id', estado_categoria);
router.get('/proyectos_areas/:id', proyectos_areas);
router.get('/categorias_proyecto', all_categorias);
router.post('/roles_proyecto', roles_proyecto);
router.get('/list_categorias', list_categorias);
router.post('/subir_pdf', upload.single('file'), subir_pdf);
router.get('/documentos_proyectos/:id', documentos_proyectos);
router.get('/pdf/:id', ver_pdf);
router.get('/guias/:id', guias_proyectos);
router.post('/upload_guia', upload_guia.single('file'), subir_guia);
router.post('/ver_guia', download_guia);

module.exports = router;