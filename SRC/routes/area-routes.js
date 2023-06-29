const { Router } = require('express');
const router = Router();

const { crear_area, all_data_area, relacionar_usuario_area, usuarios_areas, usuarios_sin_areas, todos_los_roles, data_user_area, data_area_id } = require('../controllers/Area/area-controller');

router.post('/crear_area', crear_area);
router.get('/all_area', all_data_area);
router.post('/usuario_area', relacionar_usuario_area);
router.get('/user_area/:id', usuarios_areas);
router.get('/users_sin_area', usuarios_sin_areas);
router.get('/roles', todos_los_roles);
router.get('/data_area_user/:id', data_user_area);
router.get('/data_area_id/:id', data_area_id)



module.exports = router;