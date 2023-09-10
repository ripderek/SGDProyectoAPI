const { Router } = require('express');
const router = Router();

//middleware para guardar las fotos de perfil 
//requerio el middle de multer 
const { upload } = require('../middleware/multer_perfil');

const { crear_usuario, datos_Usuarios, all_data_users, imagen_user, datos_usuario, modificar_usuario, cambiar_foto, actualizar_contrasena, crear_usuario_area, actualizar_contrasena_admin, deshabilitar_usuario, modificar_usuario_not_admin, recuperar_cuenta,total_pag_users,rol_usuario } = require('../controllers/Users/users-controller');

router.post('/crear_usuario', upload.single('file'), crear_usuario);
router.post('/crear_usuario_area', upload.single('file'), crear_usuario_area);
router.get('/User/:id', datos_Usuarios);
router.get('/Userdata/:pag', all_data_users);
router.get('/Userdatapag', total_pag_users);

router.get('/foto/:id', imagen_user)
router.get('/Datos/:id', datos_usuario);
router.post('/Editar/:id', modificar_usuario);
router.post('/EditarNotAdmin/:id', modificar_usuario_not_admin);

router.post('/Deshabilitar/:id', deshabilitar_usuario);
router.post('/Cambiar_foto', upload.single('file'), cambiar_foto);
router.post('/Actualizar_Contra', actualizar_contrasena);
router.post('/Actualizar_Contra_admin', actualizar_contrasena_admin);

router.post('/User_rol',rol_usuario);

module.exports = router;