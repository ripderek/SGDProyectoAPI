const pool = require('../../db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { serialize } = require('cookie');

const crear_usuario = async (req, res, next) => {
    try {
        const { nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, isadmin } = req.body;
        const users = await pool.query('Call Crear_Usuario($1,$2,$3,$4,$5,$6,$7,$8,$9)', [nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, isadmin]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el usuario" });
    } catch (error) {
        next(error);
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


module.exports = {
    crear_usuario,
    modificar_usuario,
    datos_Usuarios,
    all_data_users
};