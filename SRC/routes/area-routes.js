const { Router } = require('express');
const router = Router();

const { crear_area, all_data_area, relacionar_usuario_area, usuarios_areas, usuarios_sin_areas, todos_los_roles, data_user_area, data_area_id, imagen_area, areas_jerarquias, areas_usuarios, editar_datos_area, cambiar_foto, deshabilitar_usuario_area, cambiar_rol_usuario_admin, areas_para_flujos, data_area_i, areas_admin_user, datos_a_editar, all_data_area_busqueda } = require('../controllers/Area/area-controller');

const { upload } = require('../middleware/multer_area');


router.post('/crear_area', upload.single('file'), crear_area);
router.get('/all_area', all_data_area);
router.get('/all_area_busqueda/:clave', all_data_area_busqueda);
router.post('/usuario_area', relacionar_usuario_area);
router.get('/user_area/:id', usuarios_areas);
router.get('/users_sin_area/:id', usuarios_sin_areas);
router.get('/roles', todos_los_roles);
router.get('/data_area_user/:id', data_user_area);
router.get('/data_area_id/:id', data_area_id)
router.get('/Areaimagen/:id', imagen_area);
router.get('/Jerarquias/:id', areas_jerarquias);
router.post('/areas_usuario/:id', areas_usuarios);
router.post('/Editar_datos_area', editar_datos_area);
router.post('/Deshabilitar_usuario_area', deshabilitar_usuario_area);
router.post('/CambiarRol', cambiar_rol_usuario_admin)
router.get('/Flujo/:id', areas_para_flujos);
router.get('/Data/:id', data_area_i);
router.get('/Areasadmin/:id', areas_admin_user);
router.get('/DatosEditar/:id', datos_a_editar);

router.post('/Cambiar_foto_area', upload.single('file'), cambiar_foto);


module.exports = router;