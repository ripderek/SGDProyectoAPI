const pool = require('../../db');
const path = require('path');
const fs = require('fs');

//directorio de los perfiles 
let ipFileServer = "../../uploads/perfiles/";


const crear_usuario = async (req, res, next) => {
    try {

        //file de la foto
        const { file } = req
        const foto = `${ipFileServer}${file?.filename}`;
        //crear el user en la BD
        const { nombres } = req.body;
        const { tipo_identificacion } = req.body;
        const { identificacion } = req.body;
        const { correo1 } = req.body;
        const { correo2 } = req.body;
        const { celular } = req.body;
        const { firma } = req.body;
        const { isadmin } = req.body;
        const users = await pool.query('Call Crear_Usuario($1,$2,$3,$4,$5,$6,$7,$8,$9)', [nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, isadmin]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el usuario" });
    } catch (error) {
        return res.status(404).json({ message: error.constraint, });
    }
}
const modificar_usuario = async (req, res, next) => {
    return res.json({ mensaje: "Modificar Usuario" });
}
const datos_Usuarios = async (req, res, next) => {
    try {
        const { id } = req.params;

        const users = await pool.query('select * from User_Data($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        next(error);
    }
}

const all_data_users = async (req, res, next) => {
    try {
        const users = await pool.query('select * from Users_allData()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        next(error);
    }
}

//COnsulta para ver los perfiles de los usuarios 
const imagen_user = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from User_Perfil($1)', [id]);
        let ext = path.extname("7.jpg");
        let fd = fs.createReadStream(path.join(__dirname, "../" + users.rows[0].url_foto_user));
        res.setHeader("Content-Type", "image/" + ext.substr(1));
        fd.pipe(res);
    } catch (error) {
        return res.status(404).json({ message: "No se encuentra la imagen " });
    }
    //res.download('SRC/Assets/Wallpaper/Fri7zeuWIAA8Z7m.jpg'); para descargar xd 
}

module.exports = {
    crear_usuario,
    modificar_usuario,
    datos_Usuarios,
    all_data_users,
    imagen_user
};
