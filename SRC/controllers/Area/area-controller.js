const pool = require('../../db');
const fs = require('fs');


let ipFileServer = "../../uploads/areas/perfiles/";
const path = require('path');

const crear_area = async (req, res, next) => {
    try {
        //obtener la URL de la Imagen Subida del area
        const { file } = req
        const foto = `${ipFileServer}${file?.filename}`;
        //obtener los atributos mediante el form body
        const { nombre_area } = req.body;

        //Recibir un parametro para saber si se va a ingresar un area padre o hijo para no estar creando dos funciones xd 
        const { area_padre } = req.body;
        const { prefijo } = req.body;


        //area_padre = string, int, bool, url asdasdsad
        //Ty const string {area_padre} = req.bidy

        if (area_padre === "None") {
            const area = await pool.query('Call crear_area_padre($1,$2,$3)', [nombre_area, foto, prefijo]);
            console.log(area);
        }
        else {
            const area = await pool.query('Call crear_area_hijo($1,$2,$3,$4)', [nombre_area, foto, area_padre, prefijo]);
            console.log(area);
        }
        return res.status(200).json({ message: "Se creo el area" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const all_data_area = async (req, res, next) => {
    try {
        const area = await pool.query('select * from area_allData()');
        return res.status(200).json(area.rows);
    } catch (error) {
        next(error);
    }
}
const relacionar_usuario_area = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        //no se debe de enviar el rol simplemente se ingresa como false y luego se edita para que se haga admin de area 
        const { p_id_user, p_id_area } = req.body;
        const user = await pool.query('Call usuarios_areas($1,$2)', [p_id_user, p_id_area]);
        console.log(user);
        return res.status(200).json({ message: "Se asigno el usuario al area" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const usuarios_areas = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { id } = req.params;
        const user = await pool.query('select * from user_area($1)', [id]);
        console.log(user.rows);
        return res.status(200).json(user.rows);
    } catch (error) {
        console.log('asdas' + error);
        return res.status(404).json({ message: error.message });
    }
}
const usuarios_sin_areas = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { id } = req.params;
        const user = await pool.query('select * from user_sin_area1($1)', [id]);
        console.log(user.rows);
        return res.status(200).json(user.rows);
    } catch (error) {
        console.log("Sasd" + error);
        return res.status(404).json({ message: error.message });
    }
}

const areas_usuarios = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { id } = req.params;
        const { identi } = req.body;
        const user = await pool.query('select * from usuarios_areas_rol($1,$2)', [id, identi]);
        console.log(user.rows);
        return res.status(200).json(user.rows);
    } catch (error) {
        console.log(error);
        next(error)
    }
}

const todos_los_roles = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const roles = await pool.query('select * from all_roles()');
        console.log(roles.rows);
        return res.status(200).json(roles.rows);
    } catch (error) {
        console.log(error);
        next(error)
    }
}
const data_user_area = async (req, res, next) => {
    try {
        const { id } = req.params;
        const data_user = await pool.query('select * from data_user_area($1)', [id]);
        console.log(data_user.rows);
        return res.status(200).json(data_user.rows[0]);
    } catch (error) {
        console.log(error);
        next(error)
    }
}


const data_area_id = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { id } = req.params;
        const data_area = await pool.query('select * from area_allData_id($1)', [id]);
        console.log(data_area.rows);
        return res.status(200).json(data_area.rows[0]);
    } catch (error) {
        console.log(error);
        next(error)
    }
}

//COnsulta para ver las fotos de las areas
const imagen_area = async (req, res, next) => {
    try {

        const { id } = req.params;
        const users = await pool.query('select * from area_logo($1)', [id]);
        let ext = path.extname("7.jpg");
        let fd = fs.createReadStream(path.join(__dirname, "../" + users.rows[0].logoarea));
        res.setHeader("Content-Type", "image/" + ext.substr(1));
        fd.pipe(res);
    } catch (error) {
        return res.status(404).json({ message: "No se encuentra la imagen " });
    }
}

//funcion para ver la jerarquia de la area jijiji ja 
const areas_jerarquias = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { id } = req.params;
        const data_area = await pool.query('select * from jerarquias_areas($1)', [id]);
        console.log(data_area.rows);
        return res.status(200).json(data_area.rows);
    } catch (error) {
        console.log(error);
        next(error)
    }
}

const editar_datos_area = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { p_nombre_area, p_prefijo_area, id } = req.body;
        const data_area = await pool.query('Call Editar_Area($1,$2,$3)', [p_nombre_area, p_prefijo_area, id]);
        return res.status(200).json({ message: "Se edito el area" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const cambiar_foto = async (req, res, next) => {
    try {
        //obtener la URL de la Imagen Subida del area
        const { file } = req
        const p_url_foto = `${ipFileServer}${file?.filename}`;
        //obtener los atributos mediante el form body
        const { id } = req.body;

        //area_padre = string, int, bool, url asdasdsad
        //Ty const string {area_padre} = req.bidy
        const data_area = await pool.query('Call cambiar_foto_area($1,$2)', [p_url_foto, id]);
        console.log(data_area);

        return res.status(200).json({ message: "Se cambio la foto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const deshabilitar_usuario_area = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { p_id_area, p_id_user } = req.body;
        const data_area = await pool.query('Call Deshabilitar_Usuario_Area($1,$2)', [p_id_area, p_id_user]);
        console.log(data_area);

        return res.status(200).json({ message: "Se expuls'o al usuario del area" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

//cambiar el estado del usuario dentro del area 
//si es admin => normal
//else normal => admin
const cambiar_rol_usuario_admin = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const { p_id_relacion } = req.body;
        const data_area = await pool.query('Call Cambiar_Rol_Area($1)', [p_id_relacion]);
        console.log(p_id_relacion);
        console.log(data_area);
        return res.status(200).json({ message: "Se cambio su rol dentro del area" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

//para crear los flujos 
const areas_para_flujos = async (req, res, next) => {
    try {
        const { id } = req.params;
        const user = await pool.query('select * from Areas_para_flujo($1)', [id]);
        console.log(user.rows);
        return res.status(200).json(user.rows);
    } catch (error) {
        console.log('asdas' + error);
        return res.status(404).json({ message: error.message });
    }
}

const data_area_i = async (req, res, next) => {
    try {
        const { id } = req.params;
        const user = await pool.query('select * from Data_area_id($1)', [id]);
        //console.log(user.rows);
        return res.status(200).json(user.rows);
    } catch (error) {
        console.log('asdas' + error);
        return res.status(404).json({ message: error.message });
    }
}
//funcion para listar las areas que administra un usuario mediante su id de user 
const areas_admin_user = async (req, res, next) => {
    try {
        const { id } = req.params;
        const user = await pool.query('select * from areas_que_administra($1)', [id]);
        return res.status(200).json(user.rows);
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
module.exports = {
    crear_area,
    all_data_area,
    relacionar_usuario_area,
    usuarios_areas,
    usuarios_sin_areas,
    todos_los_roles,
    data_user_area,
    data_area_id,
    imagen_area,
    areas_jerarquias,
    areas_usuarios,
    editar_datos_area,
    cambiar_foto,
    deshabilitar_usuario_area,
    cambiar_rol_usuario_admin,
    areas_para_flujos,
    data_area_i,
    areas_admin_user
};