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

const crear_flujo_proyecto = async (req, res, next) => {
    try {
        const { id, id2 } = req.params;
        const { list_niveles } = req.body;

        console.log(id);
        console.log(id2);
        console.log("Lista de los niveles");
        console.log(list_niveles);
        const users = await pool.query('call Crear_flujo_Proyecto($1,$2,$3)', [id, id2, JSON.stringify(list_niveles)]);
        return res.status(200).json({ message: "Se creo el flujo del proyecto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const crear_jerarquias_nivel = async (req, res, next) => {
    try {
        console.log("aqui se crea la jeraraui");
        const { id } = req.params;
        const { list_niveles } = req.body;
        // console.log(users);
        console.log(id);
        console.log(list_niveles);
        const idcabezera = list_niveles[0].nivel_id;
        console.log("Este va a ser el id de la cabezera" + idcabezera);
        //primero crear el tipo de jerarquia enviando el titulo y luego recorrer el objeto y enviar uno por uno a la tabla jerarquias
        //
        const users = await pool.query('call Crear_Tipo_Jerarquias($1)', [id]);
        //
        //aqui recorrer con un map el list niveles y enviar uno por uno a la base de datos

        list_niveles.map((task) => {
            console.log(task.nivel_titulo);
            //aqui se envia como cabecera el id del primer nivel 
            crear_jerarquias_nivel_2(task.id_p, task.nivel_id, idcabezera);
        });


        return res.status(200).json({ message: "Se creo el flujo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

const crear_jerarquias_nivel_2 = async (id_padre, p_id_nivel_hijo, p_id_cabecera) => {
    try {
        //aqui se envia como cabecera el id del primer nivel 
        if (id_padre !== 0) {
            const niveles = await pool.query('call Crear_Jerarquias_Niveles($1,$2,$3)', [id_padre, p_id_nivel_hijo, p_id_cabecera]);
        }
    } catch (error) {
        console.log(error);
    }
}

const ver_tipos_jerarquias = async (req, res, next) => {
    try {
        const users = await pool.query('select * from Lista_tipos_jerarquias()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const ver_tipos_jerarquias_activas = async (req, res, next) => {
    try {
        const users = await pool.query('select * from Lista_tipos_jerarquias_true()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const ver_detalles__flujos = async (req, res, next) => {
    try {
        const { id } = req.params
        const users = await pool.query('select * from Detalle_jerarquia($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

const ver_detalles_niveles = async (req, res, next) => {
    try {
        const { id } = req.params
        const users = await pool.query('select * from Detalle_Flujo($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

module.exports = {
    crear_nivel,
    ver_niveles,
    ver_niveles_activos,
    crear_jerarquias_nivel,
    ver_tipos_jerarquias,
    ver_detalles__flujos,
    ver_tipos_jerarquias_activas,
    ver_detalles_niveles,
    crear_flujo_proyecto
};
