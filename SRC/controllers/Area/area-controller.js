const pool = require('../../db');

const crear_area = async (req, res, next) => {
    try {
        const { nombre_area, nivel_area, url_foto } = req.body;
        const area = await pool.query('Call crear_area($1,$2,$3)', [nombre_area, nivel_area, url_foto]);
        console.log(area);
        return res.status(200).json({ message: "Se creo el area" });
    } catch (error) {
        console.log(error);
        next(error);
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
        const { p_id_user, p_id_area, p_id_rol } = req.body;
        const user = await pool.query('Call usuarios_areas($1,$2,$3)', [p_id_user, p_id_area, p_id_rol]);
        console.log(user);
        return res.status(200).json({ message: "Se asigno el usuario al area" });
    } catch (error) {
        console.log(error);
        next(error)
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
        console.log(error);
        next(error)
    }
}
const usuarios_sin_areas = async (req, res, next) => {
    try {
        //agregar un usuario a un area
        const user = await pool.query('select * from user_sin_area()');
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
        //agregar un usuario a un area
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

module.exports = {
    crear_area,
    all_data_area,
    relacionar_usuario_area,
    usuarios_areas,
    usuarios_sin_areas,
    todos_los_roles,
    data_user_area,
    data_area_id
};