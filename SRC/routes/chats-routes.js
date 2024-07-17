const { Router } = require('express');
const router = Router();
const { visualizar_chat_img,insertar_chat_text, insertar_chat_img,visualizar_chat} = require('../controllers/chats/chats-controller');

const { upload } = require('../middleware/multer_chats');

router.post('/insertar_chat_text', insertar_chat_text);
router.post('/insertar_chat_img',upload.single('file'), insertar_chat_img);
router.get('/visualizar_chat/:idproyecto', visualizar_chat);
router.get('/visualizar_chat_img/:r_id_chat', visualizar_chat_img);

module.exports = router; 