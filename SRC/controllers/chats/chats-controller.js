const pool = require('../../db');
const path = require('path');
const fs = require('fs');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');

//directorio de los perfiles
let ipFileServer = "../../uploads/chats/";

const insertar_chat_text = async (req, res, next) => {
  try {
    //Registrar los chat de los usuarios
    const { p_id_proyecto, p_id_usuario,p_tipo_mensaje, p_mensaje} = req.body;

    const chat = await pool.query("Call sp_registrar_chat($1,$2,$3,$4)", [
        p_id_proyecto,
        p_id_usuario,
        p_tipo_mensaje,
        p_mensaje,
    ]);
    //console.log(p_id_proyecto +" "+ p_id_usuario +" "+ p_tipo_mensaje +" "+ p_mensaje );
    return res.status(200).json({ message: "Se registro el chat correctamente" });
  } catch (error) {
    console.log(error);
    return res.status(404).json({ message: error.message });
  }
};

const insertar_chat_img = async (req, res, next) => {
    try {
      //Registrar los chat  de img de los usuarios
      //file de la foto
      const { file } = req
      const p_mensaje = `${ipFileServer}${file?.filename}`;
      //otros datos
      const { p_id_proyecto, p_id_usuario,p_tipo_mensaje} = req.body;
  
      const chat = await pool.query("Call sp_registrar_chat($1,$2,$3,$4)", [
          p_id_proyecto,
          p_id_usuario,
          p_tipo_mensaje,
          p_mensaje,
      ]);
      //console.log(p_id_proyecto +" "+ p_id_usuario +" "+ p_tipo_mensaje +" "+ p_mensaje );
      return res.status(200).json({ message: "Se registro el chat correctamente" });
    } catch (error) {
      console.log(error);
      return res.status(404).json({ message: error.message });
    }
  };

const visualizar_chat = async (req, res, next) => {
  try {
    const { idproyecto } = req.params;
    //console.log(idproyecto);
    const chats = await pool.query("select * from lista_chats_proyecto($1)", [
        idproyecto,
    ]);
    //console.log(chats.rows);
    return res.status(200).json(chats.rows);
  } catch (error) {
    console.log("asdas" + error);
    return res.status(404).json({ message: error.message });
  }
};

const visualizar_chat_img = async (req, res, next) => {
    try {
        const { r_id_chat } = req.params;
        const users = await pool.query('select * from img_chat_id($1)', [r_id_chat]);
        let ext = path.extname("7.jpg");
        let fd = fs.createReadStream(path.join(__dirname, "../" + users.rows[0].r_img_chat));
        //console.log(r_id_chat);
        //console.log(users.rows[0].r_img_chat);
        res.setHeader("Content-Type", "image/" + ext.substr(1));
        fd.pipe(res);
    } catch (error) {
        return res.status(404).json({ message: "No se encuentra la imagen " });
    }
  };

module.exports = {
  visualizar_chat,
  insertar_chat_text,
  insertar_chat_img,
  visualizar_chat_img,
};
