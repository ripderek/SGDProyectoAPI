const { Router } = require('express');
const router = Router();

const { crear_area, all_data_area, relacionar_usuario_area, usuarios_areas, usuarios_sin_areas } = require('../controllers/Area/area-controller');

router.post('/crear_area', crear_area);
router.get('/all_area', all_data_area);
router.post('/usuario_area', relacionar_usuario_area);
router.get('/user_area/:id', usuarios_areas);
router.get('/users_sin_area', usuarios_sin_areas);


module.exports = router;