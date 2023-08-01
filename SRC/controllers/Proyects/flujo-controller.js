const pool = require('../../db');


const crear_nivel = async (req, res, next) => {
    try {
        const { p_titulo, p_descripcion, p_cardinalidad } = req.body;
        const users = await pool.query('call Crear_Nivel($1,$2,$3)', [p_titulo, p_descripcion, p_cardinalidad]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el nivel" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const ver_niveles = async (req, res, next) => {
    try {
        const users = await pool.query('select * from ver_niveles()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const ver_niveles_activos = async (req, res, next) => {
    try {
        const users = await pool.query('select * from ver_niveles_activos()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

module.exports = {
    crear_nivel,
    ver_niveles,
    ver_niveles_activos
};
