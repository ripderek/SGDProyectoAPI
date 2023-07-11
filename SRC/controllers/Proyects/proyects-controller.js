//aqui van las funciones del modulo proyecto 
const pool = require('../../db');
const path = require('path');
const fs = require('fs');

const crear_proyecto = async (req, res, next) => {
    try {
        const { p_titulo, p_id_area, p_id_categoria, p_prefijo_proyecto } = req.body;
        const users = await pool.query('call crear_proyecto($1,$2,$3,$4)', [p_titulo, p_id_area, p_id_categoria, p_prefijo_proyecto]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el proyecto" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const crear_categoria = async (req, res, next) => {
    try {
        const { p_nombre, p_prefijo, p_descripcion } = req.body;
        const users = await pool.query('call crear_categoria_proyecto($1,$2,$3)', [p_nombre, p_prefijo, p_descripcion]);
        console.log(users);
        return res.status(200).json({ message: "Se creo la categoria" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

module.exports = {
    crear_proyecto,
    crear_categoria
};
