const { Router } = require('express');
const router = Router();

const { crear_proyecto, crear_categoria, proyectos_areas } = require('../controllers/Proyects/proyects-controller');

//tengo que crear un trigger que inserte el codigo del proyecto 
router.post('/crear_proyecto', crear_proyecto);
router.post('/crear_categoria', crear_categoria);
router.get('/proyectos_areas/:id', proyectos_areas);

module.exports = router;