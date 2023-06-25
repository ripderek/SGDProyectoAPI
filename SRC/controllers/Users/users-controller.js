const pool = require('../../db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { serialize } = require('cookie');

const crear_usuario = async (req, res, next) => {
    try {
        const { nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, contra, isadmin } = req.body;
        const users = await pool.query('Call Crear_Usuario($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)', [nombres, tipo_identificacion, identificacion, correo1, correo2, celular, foto, firma, contra, isadmin]);
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
    return res.json({ mensaje: "Datos Usuario" });
}


module.exports = {
    crear_usuario,
    modificar_usuario,
    datos_Usuarios
};