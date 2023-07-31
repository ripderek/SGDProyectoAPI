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
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}


const crear_usuario_area = async (req, res, next) => {
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
        const { id_area } = req.body;

        //console.log("Eeste es el rol" + rol);


        const users = await pool.query('Call Crear_Usuario_area($1,$2,$3,$4,$5,$6,$7,$8,$9)', [nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, id_area]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el usuario" });

    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}



const modificar_usuario = async (req, res, next) => {
    try {
        const { nombres, tipoidentifiacion, identificacion, correo1, correo2, celular, firma } = req.body;
        const { id } = req.params;

        const users = await pool.query('call Editar_Usuario($1,$2,$3,$4,$5,$6,$7,$8)', [nombres, tipoidentifiacion, identificacion, correo1, correo2, celular, firma, id]);
        console.log(users);
        return res.status(200).json({ message: "Se edito el usuario" });
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}

const modificar_usuario_not_admin = async (req, res, next) => {
    try {
        const { nombres, tipoidentifiacion, identificacion, correo1, correo2, celular, firma } = req.body;
        const { id } = req.params;

        const users = await pool.query('call Editar_Usuario_not_admin($1,$2,$3,$4)', [correo1, celular, firma, id]);
        console.log(users);
        return res.status(200).json({ message: "Se edito el usuario" });
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
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

const datos_usuario = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from data_user_p($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        next(error);
    }
}

const cambiar_foto = async (req, res, next) => {
    try {

        //file de la foto
        const { file } = req
        const foto = `${ipFileServer}${file?.filename}`;
        //crear el user en la BD
        const { id_user } = req.body;

        const users = await pool.query('Call Cambiar_Foto($1,$2)', [foto, id_user]);
        console.log(id_user + foto);
        return res.status(200).json({ message: "Se cambio la foto" });
    } catch (error) {
        return res.status(404).json({ message: error.constraint });
    }
}
const actualizar_contrasena = async (req, res, next) => {
    try {
        const { contra_nueva, contra_nueva1, contra_actual, id } = req.body;
        if (contra_nueva === contra_nueva1) {
            //primero verificar si la contrase actual y el id coinciden 
            const verific = await pool.query('select * from verficiar_contrasena_id($1,$2)', [contra_actual, id]);
            console.log(verific);

            if (verific.rowCount === 0)
                return res.status(404).json({ message: "La contrasena alctual no coincide" });
            else { const users = await pool.query('call cambiar_contra($1,$2,$3)', [contra_nueva, contra_actual, id]); }

            // const users = await pool.query('call cambiar_contra($1,$2,$3)', [contra_nueva, contra_actual, id]);
            //console.log('Aqui va el cambio de contra');
            return res.status(200).json({ message: "Se edito el usuario" });
        } else {
            return res.status(404).json({ message: "Las contrasenas no coinciden" });
        }

    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });

    }
}


const actualizar_contrasena_admin = async (req, res, next) => {
    try {
        const { contra_nueva, contra_nueva1, id } = req.body;
        if (contra_nueva === contra_nueva1) {

            const users = await pool.query('call Cambiar_Contra_admin($1,$2)', [contra_nueva, id]);

            return res.status(200).json({ message: "Se edito el usuario" });
        } else {
            return res.status(404).json({ message: "Las contrasenas no coinciden" });
        }

    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });

    }
}


const deshabilitar_usuario = async (req, res, next) => {
    try {
        const { id } = req.params;
        console.log("CambiarEstado user");
        console.log(id);
        const users = await pool.query('call Deshabilitar_Usuario($1)', [id]);
        console.log(users);
        return res.status(200).json({ message: "Se Deshabilito el usuario" });
    } catch (error) {
        console.log("este es el error");
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}



module.exports = {
    crear_usuario,
    modificar_usuario,
    datos_Usuarios,
    all_data_users,
    imagen_user,
    datos_usuario,
    cambiar_foto,
    actualizar_contrasena,
    crear_usuario_area,
    actualizar_contrasena_admin,
    deshabilitar_usuario,
    modificar_usuario_not_admin
};
