const pool = require('../../db');


const crear_nivel = async (req, res, next) => {
    try {
        const { p_titulo, p_descripcion } = req.body;
        const users = await pool.query('call Crear_Nivel($1,$2)', [p_titulo, p_descripcion]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el nivel" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

module.exports = {
    crear_nivel
};
