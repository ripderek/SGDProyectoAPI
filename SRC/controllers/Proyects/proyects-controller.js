//aqui van las funciones del modulo proyecto 
const pool = require('../../db');
const fs = require('fs');
let ipFileServer = "../../uploads/proyectos/";
const { extname } = require('path');
const path = require('path');
const puppeteer = require('puppeteer');
var pdf = require("pdf-creator-node");

//para editar el pdf i y firmarlo
const { PDFDocument, rgb, StandardFonts, PDFHexString, PDFArray, PDFSignature, PDFAcroSignature } = require('pdf-lib');
const crear_proyecto = async (req, res, next) => {
    try {
        const { p_titulo, p_id_area, p_id_categoria, p_prefijo_proyecto } = req.body;

        if (!p_id_categoria)
            return res.status(404).json({ message: "Seleccione una categoria" });


        const users = await pool.query('call crear_proyecto($1,$2,$3,$4)', [p_titulo, p_id_area, p_id_categoria, p_prefijo_proyecto]);
        console.log(users);
        return res.status(200).json({ message: "Se creo el proyecto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const editar_categoria = async (req, res, next) => {
    try {
        const { p_nombres, p_prefijo, p_descripcion, p_id_categoria } = req.body;
        const users = await pool.query('call Editar_Categoria($1,$2,$3,$4)', [p_nombres, p_prefijo, p_descripcion, p_id_categoria]);
        console.log(users);
        return res.status(200).json({ message: "Se creo edito la categoria" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const subir_pdf = async (req, res, next) => {
    try {
        const { id } = req.body;
        const { descripcion } = req.body;
        const { file } = req;
        const documento = `${ipFileServer}${file?.filename}`;
        console.log(descripcion);
        //recolectar la informacion de ese proyecto para ponerlo como encabezado 
        const dataProyect = await pool.query('select * from pro_encabezado($1)', [id]);
        console.log(dataProyect.rows[0].r_titulo);
        //return res.status(200).json(users.rows[0]);
        //obtener la imagen de la empresa 
        //const jpgUrl = 'https://pdf-lib.js.org/assets/cat_riding_unicorn.jpg'
        const urlFotoEmpresa = path.join(__dirname, "../" + dataProyect.rows[0].r_url_foto_empresa)
        //const pngImageBytes = await fetch(urlFotoEmpresa).then((res) => res.arrayBuffer())
        const pngImageBytesBuffer = await fs.readFileSync(urlFotoEmpresa);
        const pngImageBytes = pngImageBytesBuffer.buffer;
        //aqui editar el pdf para ponerle el encabezado de pagina 
        //prueba de como se modifica un documento pdf 
        //documento es la ruta del documento
        console.log(documento);
        //../../uploads/proyectos/PrototipoT-UTEQ-0090-1691544023165.pdf
        const urlArchivos = path.join(__dirname, "../" + documento)
        const buffer = await fs.readFileSync(urlArchivos);
        const pdfDoc = await PDFDocument.load(buffer)
        const pngImage = await pdfDoc.embedPng(pngImageBytes)
        const pngDims = pngImage.scale(0.1)
        //const pages = pdfDoc.getPages()
        console.log("Paguinas del doc" + pdfDoc.getPages().length);
        //desde aqui es para editar el documento pdf xd 
        const pages = pdfDoc.getPages();
        // const { width, height } = pdfDoc.getSize();
        let fontsize = 10
        //rectangulo xd 
        const opacidad = 0.6
        const font = await pdfDoc.embedFont(StandardFonts.HelveticaBold);
        //pages[0].drawText('PDF MODIFICADO BY RIP DEREK para el encabezado')
        for (i = 0; i < pdfDoc.getPages().length; i++) {
            //const pages = pdfDoc.getPages();
            //obtener la paguina y su tamanao
            const pageActually = pages[i]
            const { width, height } = pageActually.getSize()
            //rectagulo princiapl 

            //rectagunlo para la foto de la empresa xd 
            pageActually.drawRectangle({
                x: 12,
                y: height / 2 + 300,
                width: 100,
                height: 100,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //primer fila
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 380,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //segunda fila
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 360,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //tercer fila 
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 340,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 320,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //cuarta fila 
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 300,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //aqui es donde tengo que crear la tabla con el encabezado y ponerla en el nuevo doc 
            //titulo del sistema
            pageActually.drawText("Sistema de Gestión de la Calidad de la UTEQ", {
                x: 117,
                y: height / 2 + 385,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //titulo del proyecto
            pageActually.drawText(dataProyect.rows[0].r_titulo, {
                x: 117,
                y: height / 2 + 365,
                size: fontsize,
                opacity: opacidad


            })
            //codigo del proyecto

            pageActually.drawText("Codigo: ", {
                x: 117,
                y: height / 2 + 345,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            /*
            pageActually.drawText(dataProyect.rows[0].r_codigo, {
                x: 165,
                y: height / 2 + 345,
                size: fontsize
            })
            */
            //area responsable
            pageActually.drawText("Responsable: ", {
                x: 117,
                y: height / 2 + 325,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            pageActually.drawText(dataProyect.rows[0].r_area_responsable, {
                x: 185,
                y: height / 2 + 325,
                size: fontsize,
                opacity: opacidad

            })
            //version del proyecto: 
            pageActually.drawText("Version: ", {
                x: 117,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //version del proyecto ya no se agrega al subir un pdf o un documento extra porque puede cambiar 
            //esto anadirlo cuando se prepare el documento
            /*
            pageActually.drawText(dataProyect.rows[0].r_version, {
                x: 170,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
            })
            */
            //fecha de publicacion
            pageActually.drawText("Fecha: ", {
                x: 250,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //Numero de pagina
            pageActually.drawText("Pagina: ", {
                x: 400,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //dibujar la foto  de la empresa
            pageActually.drawImage(pngImage, {
                x: 22,
                y: height / 2 + 302,
                width: pngDims.width,
                height: pngDims.height,
                opacity: opacidad

            })
        }
        //hasta aqui
        //el resto es para guardar el pdf xd
        //const pdfBytes = await pdfDoc.save()
        //con este se guarda el archivo
        //fs.writeFileSync("./output1.pdf", await pdfDoc.save());
        console.log("Nombre del archivo");
        const fileExtension = extname(file.originalname);
        //console.log(fileExtension);
        //console.log(file.filename.split(fileExtension)[0]);
        const fileName = file.filename.split(fileExtension)[0] + "-Cabezera";
        const documento_editado = `${fileName}${fileExtension}`;
        //cb(null, `${fileName}-${Date.now()}${fileExtension}`);
        console.log(documento_editado);
        //al guardarlo ponerle un -cabezera al nombre del documento para guardarlo xd
        //`${ipFileServer}${documento_editado?documento_editado}`
        const rutaCabezera = `${ipFileServer}${documento_editado}`
        console.log("Ruta a enviar a la bd" + rutaCabezera);
        fs.writeFileSync("./uploads/proyectos/" + documento_editado, await pdfDoc.save());
        //almacenaren la base de datos el nuevo documento xd 
        const users = await pool.query('call documento_proyecto($1,$2,$3)', [rutaCabezera, id, descripcion]);
        console.log(users);
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error);
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
const estado_categoria = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('call Estado_Categoria($1)', [id]);
        console.log(users);
        return res.status(200).json({ message: "Se edito el estado de  la categoria" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const proyectos_areas = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { id2 } = req.params;

        const users = await pool.query('select * from proyectos_areas($1,$2)', [id, id2]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const all_categorias = async (req, res, next) => {
    try {
        const users = await pool.query('select * from categorias_proyectos()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const list_categorias = async (req, res, next) => {
    try {
        const users = await pool.query('select * from Lis_categorias()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const roles_proyecto = async (req, res, next) => {
    try {
        const { p_id_user, p_id_proyect } = req.body;
        const users = await pool.query('select * from rol_proyecto($1,$2)', [p_id_user, p_id_proyect]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const documentos_proyectos = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_docs($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const ver_pdf = async (req, res) => {
    try {
        const { id } = req.params;

        const users = await pool.query('select * from ver_docs_x_id($1)', [id]);
        const urlArchivos = path.join(__dirname, "../" + users.rows[0].d_url)

        var data = fs.readFileSync(urlArchivos);
        res.contentType("application/pdf");
        res.send(data);
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}
//ver el pdf modifcado con los otros documentos anadidos 
const ver_pdf_2 = async (req, res) => {
    try {
        const { id } = req.params;

        const users = await pool.query('select * from ver_docs_x_id_2($1)', [id]);
        const urlArchivos = path.join(__dirname, "../" + users.rows[0].d_url)

        var data = fs.readFileSync(urlArchivos);
        res.contentType("application/pdf");
        res.send(data);
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}
//Ver pdf solo enviar la URL del doc
const ver_pdf_url = async (req, res) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from Ver_URL_Extra($1)', [id]);
        const urlArchivos = path.join(__dirname, "../" + users.rows[0].p_url_doc)
        var data = fs.readFileSync(urlArchivos);
        res.contentType("application/pdf");
        res.send(data);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const guias_proyectos = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from List_Guias_proyectos($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//Nuevo agregado desde la pc de Herrera
let ipFileServerGuia = "../../uploads/Guias/";
const subir_guia = async (req, res, next) => {
    try {
        const { id } = req.body;
        const { file } = req;
        const documento = `${ipFileServerGuia}${file?.filename}`;
        //let ext = path.extname(file);
        const { descripcion } = req.body;
        console.log(documento);
        const extension = extname(file.originalname);
        const ext = file.originalname.split(extension)[1];
        console.log(extension);
        console.log(ext);
        console.log("aqui se envia el archivo");
        if (!descripcion) return res.status(404).json({ message: "Descripcion no puede ser vacio" });

        const users = await pool.query('call subir_guia($1,$2,$3,$4)', [documento, id, extension, descripcion]);
        console.log(users);
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const download_guia = async (req, res) => {
    console.log("descargar guia");
    try {
        const { link } = req.body;

        const urlArchivos = path.join(__dirname, "../" + link)

        console.log(urlArchivos);
        return res.download(urlArchivos);

        //res.download( link);
        //console.log(link);
        //return res.status(200).json({ message: "se descarga el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const ver_flujo_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_FLujo_Proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const borradores_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_borradores_proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const proyect_data = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from data_proyect($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const niveles_estado = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from niveles_estado_proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const ver_flujo_proyecto_nivel2 = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_FLujo_Proyecto_nivel2($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const subir_primer_nivel = async (req, res, next) => {
    try {
        //SI EL PROYECTO TIENE REFORMA = TRUE ENTONCES SE DEBE DE SUMAR EL PESO DEL FLUJO SELECCIONADO CON LA VERSION ACTUAL DEL PROYECTO Y HACER UN UPDATE DE LA VERSION Y DEL CODIGO DEL PROYECTO SKERE MODO DIABLO
        const { list_niveles } = req.body;
        const users = await pool.query('call subir_primer_nivel($1)', [JSON.stringify(list_niveles)]);
        return res.status(200).json({ message: "Se subio de nivel el proyecto" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const id_doc = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from doc_id($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const subir_level = async (req, res, next) => {
    try {
        const { id } = req.params;
        //primero necesito obtener el primer pdf que seria el documento actual del proyecto de la columna 'url2'
        //devuelve un registro
        const documento_subido = await pool.query('select * from ver_doc_modificado($1)', [id]);
        //segundo necesito todos los documentos extras con esta en true para juntarlo 
        //devuelve varios
        const documentos_extras = await pool.query('select * from Ver_documentos_extras($1)', [id]);
        //antes de empezar a unir los pdf se debe preguntar si existen o no documentos apra ajuntar 
        //de no existir simplemente se omite este paso 
        let nuevaURL = '';
        if (documentos_extras.rows.length != 0) {
            console.log("El proyecto tiene documentos extras" + id);
            //como tiene documentos extras tengo que recorrerlos 
            //aqui tiene que crearse y copiarse primero todas las paguinas del primer documento (url_modificado)
            console.log("Documento original");
            console.log(documento_subido.rows[0].p_url_doc);
            //conversiona bytes del documento base 
            //const urlDocBase = path.join(__dirname, "../" + documento_subido.rows[0].p_url_doc)
            // const DocBaseBuffer = await fs.readFileSync(urlDocBase);
            //const DocBytes = await PDFDocument.load(DocBaseBuffer)
            const VectorConDocumentos = [];
            VectorConDocumentos.push(documento_subido.rows[0].p_url_doc);
            for (var i = 0; i < documentos_extras.rows.length; i++) {
                //  Agregar elementos al vector
                VectorConDocumentos.push(documentos_extras.rows[i].r_url_doc);
            }
            //console.log("URLDOCUMENTOS: " + VectorConDocumentos);
            //las url de los documeton estan en el vector
            const pdfDoc = await PDFDocument.create();
            for (const pdfBytes of VectorConDocumentos) {
                //primero obtener el buffer del documento xd 
                const urlDocBase = path.join(__dirname, "../" + pdfBytes)
                const DocBaseBuffer = await fs.readFileSync(urlDocBase);
                const DocBytes = await PDFDocument.load(DocBaseBuffer)
                const copiedPages = await pdfDoc.copyPages(DocBytes, DocBytes.getPageIndices());
                copiedPages.forEach((page) => {
                    pdfDoc.addPage(page);
                });
            }
            //guardar el pdf 
            var nuevaURL2 = "./uploads/proyectos/" + 'documentomodificado' + Date.now() + '.pdf';
            fs.writeFileSync(nuevaURL2, await pdfDoc.save());
            //../.
            nuevaURL = '../.' + nuevaURL2;
        }
        else {
            console.log('El proyecto no tiene documetos extras' + id);
            nuevaURL = documento_subido.rows[0].p_url_doc;
        }
        const users = await pool.query('call subir_niveles($1,$2)', [id, nuevaURL]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
const publicar_doc = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('call publicar_doc($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const proyectos_publicados = async (req, res, next) => {
    try {
        const users = await pool.query('select * from ver_proyectos_publicados()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
const deshabilitar_flujo = async (req, res, next) => {
    try {
        const { id } = req.params;
        console.log("Aqui se envia a cambiar");
        const users = await pool.query('call cambiar_estado_flujo($1)', [id]);
        console.log(users);
        return res.status(200).json({ message: "Se deshalibito el flujo" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para rechazar el proyecto en cualquier nivel que se encuentre ostia puta xd 
const rechazar_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { descripcionp } = req.body
        const users = await pool.query('call rechazar_proyecto($1,$2)', [id, descripcionp]);
        console.log(users);
        return res.status(200).json(users.rows[0]);
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//funcion para ver el historial de un proyecto 
const historial_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_historial_proyecto($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para ver el flujo rechazado xd  
const ver_flujo_rechazado = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_flujo_rechazado($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para ver el flujo que se creo desde el historial del proyecto 
const ver_flujo_historial = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from flujo_Historial($1)', [id]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para ver los documentos extras que ha subido un nivel en un proyecto
const ver_documentos_extras = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from Ver_documentos_extras($1)', [id]);
        //console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para ver los documentos contraportadas 
const ver_documentos_contraportadas = async (req, res, next) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from Ver_contraportadas($1)', [id]);
        //console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para subir los documentos extras segun el nivel 
const subir_pdf_extra = async (req, res, next) => {
    try {
        const { id } = req.body;
        const { descripcion } = req.body;
        const { file } = req;
        const documento = `${ipFileServer}${file?.filename}`;
        console.log(descripcion);
        //recolectar la informacion de ese proyecto para ponerlo como encabezado 
        const dataProyect = await pool.query('select * from pro_encabezado($1)', [id]);
        console.log(dataProyect.rows[0].r_titulo);
        //return res.status(200).json(users.rows[0]);
        //obtener la imagen de la empresa 
        //const jpgUrl = 'https://pdf-lib.js.org/assets/cat_riding_unicorn.jpg'
        const urlFotoEmpresa = path.join(__dirname, "../" + dataProyect.rows[0].r_url_foto_empresa)
        //const pngImageBytes = await fetch(urlFotoEmpresa).then((res) => res.arrayBuffer())
        const pngImageBytesBuffer = await fs.readFileSync(urlFotoEmpresa);
        const pngImageBytes = pngImageBytesBuffer.buffer;
        //aqui editar el pdf para ponerle el encabezado de pagina 
        //prueba de como se modifica un documento pdf 
        //documento es la ruta del documento
        console.log(documento);
        //../../uploads/proyectos/PrototipoT-UTEQ-0090-1691544023165.pdf
        const urlArchivos = path.join(__dirname, "../" + documento)
        const buffer = await fs.readFileSync(urlArchivos);
        const pdfDoc = await PDFDocument.load(buffer)
        const pngImage = await pdfDoc.embedPng(pngImageBytes)
        const pngDims = pngImage.scale(0.1)
        //const pages = pdfDoc.getPages()
        console.log("Paguinas del doc" + pdfDoc.getPages().length);
        //desde aqui es para editar el documento pdf xd 
        const pages = pdfDoc.getPages();
        // const { width, height } = pdfDoc.getSize();
        let fontsize = 10
        //rectangulo xd 
        const font = await pdfDoc.embedFont(StandardFonts.HelveticaBold);
        const opacidad = 0.6

        //pages[0].drawText('PDF MODIFICADO BY RIP DEREK para el encabezado')
        for (i = 0; i < pdfDoc.getPages().length; i++) {
            //const pages = pdfDoc.getPages();
            //obtener la paguina y su tamanao
            const pageActually = pages[i]
            const { width, height } = pageActually.getSize()
            //rectagulo princiapl 

            //rectagunlo para la foto de la empresa xd 
            pageActually.drawRectangle({
                x: 12,
                y: height / 2 + 300,
                width: 100,
                height: 100,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //primer fila
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 380,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //segunda fila
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 360,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //tercer fila 
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 340,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 320,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //cuarta fila 
            pageActually.drawRectangle({
                x: 113,
                y: height / 2 + 300,
                width: width - 137,
                height: 20,
                color: rgb(1, 1, 1),
                borderWidth: 1.5,
                opacity: opacidad

            })
            //aqui es donde tengo que crear la tabla con el encabezado y ponerla en el nuevo doc 
            //titulo del sistema
            pageActually.drawText("Sistema de Gestión de la Calidad de la UTEQ", {
                x: 117,
                y: height / 2 + 385,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //titulo del proyecto
            pageActually.drawText(dataProyect.rows[0].r_titulo, {
                x: 117,
                y: height / 2 + 365,
                size: fontsize,
                opacity: opacidad

            })
            //codigo del proyecto
            pageActually.drawText("Codigo: ", {
                x: 117,
                y: height / 2 + 345,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            /*
            pageActually.drawText(dataProyect.rows[0].r_codigo, {
                x: 165,
                y: height / 2 + 345,
                size: fontsize
            })
            */
            //area responsable
            pageActually.drawText("Responsable: ", {
                x: 117,
                y: height / 2 + 325,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            pageActually.drawText(dataProyect.rows[0].r_area_responsable, {
                x: 185,
                y: height / 2 + 325,
                size: fontsize,
                opacity: opacidad

            })
            //version del proyecto: 
            pageActually.drawText("Version: ", {
                x: 117,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            /*
            pageActually.drawText(dataProyect.rows[0].r_version, {
                x: 170,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
            })
            */
            //fecha de publicacion
            pageActually.drawText("Fecha: ", {
                x: 250,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //Numero de pagina
            pageActually.drawText("Pagina: ", {
                x: 400,
                y: height / 2 + 305,
                size: fontsize,
                font: font,
                opacity: opacidad

            })
            //dibujar la foto  de la empresa
            pageActually.drawImage(pngImage, {
                x: 22,
                y: height / 2 + 302,
                width: pngDims.width,
                height: pngDims.height,
                opacity: opacidad

            })
        }
        //hasta aqui
        //el resto es para guardar el pdf xd
        //const pdfBytes = await pdfDoc.save()
        //con este se guarda el archivo
        //fs.writeFileSync("./output1.pdf", await pdfDoc.save());
        console.log("Nombre del archivo");
        const fileExtension = extname(file.originalname);
        //console.log(fileExtension);
        //console.log(file.filename.split(fileExtension)[0]);
        const fileName = file.filename.split(fileExtension)[0] + "-Cabezera";
        const documento_editado = `${fileName}${fileExtension}`;
        //cb(null, `${fileName}-${Date.now()}${fileExtension}`);
        console.log(documento_editado);
        //al guardarlo ponerle un -cabezera al nombre del documento para guardarlo xd
        //`${ipFileServer}${documento_editado?documento_editado}`
        const rutaCabezera = `${ipFileServer}${documento_editado}`
        console.log("Ruta a enviar a la bd" + rutaCabezera);
        fs.writeFileSync("./uploads/proyectos/" + documento_editado, await pdfDoc.save());
        console.log("datos");
        console.log("id: " + id);
        console.log("descripcion" + descripcion);
        //almacenaren la base de datos el nuevo documento xd 
        const users = await pool.query('call insertar_documentos_extras($1,$2,$3)', [rutaCabezera, id, descripcion]);
        console.log(users);
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//combinar pdf sin guardar en la base de datos 
const combinar_pdfs = async (req, res, next) => {
    try {
        const { id } = req.params;
        //primero necesito obtener el primer pdf que seria el documento actual del proyecto de la columna 'url2'
        //devuelve un registro
        const documento_subido = await pool.query('select * from ver_doc_modificado($1)', [id]);
        //segundo necesito todos los documentos extras con esta en true para juntarlo 
        //devuelve varios
        const documentos_extras = await pool.query('select * from Ver_documentos_extras($1)', [id]);
        //antes de empezar a unir los pdf se debe preguntar si existen o no documentos apra ajuntar 
        //de no existir simplemente se omite este paso 
        if (documentos_extras.rows.length != 0) {
            console.log("El proyecto tiene documentos extras" + id);
            //como tiene documentos extras tengo que recorrerlos 
            //aqui tiene que crearse y copiarse primero todas las paguinas del primer documento (url_modificado)
            console.log("Documento original");
            console.log(documento_subido.rows[0].p_url_doc);
            //conversiona bytes del documento base 
            //const urlDocBase = path.join(__dirname, "../" + documento_subido.rows[0].p_url_doc)
            // const DocBaseBuffer = await fs.readFileSync(urlDocBase);
            //const DocBytes = await PDFDocument.load(DocBaseBuffer)
            const VectorConDocumentos = [];
            VectorConDocumentos.push(documento_subido.rows[0].p_url_doc);
            for (var i = 0; i < documentos_extras.rows.length; i++) {
                //  Agregar elementos al vector
                VectorConDocumentos.push(documentos_extras.rows[i].r_url_doc);
            }
            //console.log("URLDOCUMENTOS: " + VectorConDocumentos);
            //las url de los documeton estan en el vector
            const pdfDoc = await PDFDocument.create();
            for (const pdfBytes of VectorConDocumentos) {
                //primero obtener el buffer del documento xd 
                const urlDocBase = path.join(__dirname, "../" + pdfBytes)
                const DocBaseBuffer = await fs.readFileSync(urlDocBase);
                const DocBytes = await PDFDocument.load(DocBaseBuffer)
                const copiedPages = await pdfDoc.copyPages(DocBytes, DocBytes.getPageIndices());
                copiedPages.forEach((page) => {
                    pdfDoc.addPage(page);
                });
            }
            //guardar el pdf 
            const nuevaURL = "./uploads/proyectos/" + documento_subido.rows[0].p_titulo + Date.now() + '.pdf';
            fs.writeFileSync(nuevaURL, await pdfDoc.save());
        }
        else { console.log('El proyecto no tiene documetos extras' + id); }
        return res.status(200).json({ message: "Se combinaron los pdf" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//funcion que retorne los participantes actuales de un proyecto 
const participantes_actuales_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { id2 } = req.params;
        const users = await pool.query('select * from Participantes_Actuales_Proyecto($1,$2)', [id, id2]);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion que retorne los usuarios que no estan dentro del proyecto de un area para agregarlos xdxd skere 
const participantes_sin_proyectos = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { id2 } = req.params;
        const users = await pool.query('select * from Lista_Participantes_Proyecto($1,$2)', [id, id2]);
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//funcion para agregar un usuario al proyecto 
const agregar_usuario_proyecto = async (req, res, next) => {
    try {
        const { p_proyecto_id, p_id_relacion, p_id_rol } = req.body;
        const users = await pool.query('call agregar_usuario_proyecto($1,$2,$3)', [p_proyecto_id, p_id_relacion, p_id_rol]);
        console.log(users);
        return res.status(200).json({ message: "Se añadió al usuario" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para expulsar usuario de un proyecto 
const expulsar_usuario_proyecto = async (req, res, next) => {
    try {
        const { p_proyecto_id, p_id_relacion, p_id_rol } = req.body;
        const users = await pool.query('call expulsar_usuario_proyecto($1,$2)', [p_proyecto_id, p_id_relacion]);
        console.log(users);
        return res.status(200).json({ message: "Se expulso al usuario" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//generar la caratula prueba 

const generar_caratula = async (req, res, next) => {
    try {
        //primero pedir el titulo del proyecto mediantes el id del params 

        const { id } = req.params;
        const users = await pool.query('select * from  titulo_proyecto_pdf($1)', [id]);

        const tituloDelDocumento = users.rows[0].r_titulo_proyecto;

        //esto sive para generar la caratula 
        (async () => {
            //const urlFotoEmpresa = path.join(__dirname, "../" + dataProyect.rows[0].r_url_foto_empresa)
            //../../uploads/perfiles/logo_empresa-1690769537460.png
            const urlCaratula = path.join(__dirname, "../" + "../../uploads/Galeria/caratula.jpg");
            const browser = await puppeteer.launch();
            const page = await browser.newPage();
            const chunks = fs.readFileSync(urlCaratula).toString('base64');
            const content = `
              <!DOCTYPE html>
              <html>
              <head> 
              <style>
              body {
                background-image: url("data:image/jpeg;base64,${chunks}");
                background-size: cover;
                width: 21cm;
                height: 29.7cm;
                padding: 15mm;
                margin: 0;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
              }
              h1 {
                margin-top: 80px; 
              }
            </style>   
              </head>
              <body>
              <div>
                <h1>${tituloDelDocumento}</h1>
                </div>
              </body>
              </html>
            `;
            //uploads\Galeria\caratula.jpg
            await page.setContent(content);
            await page.pdf({ path: 'output.pdf', format: 'A4', printBackground: true });

            await browser.close();
        })();
        //hasta aqui genera la caratula
        return res.status(200).json({ message: "Se genero la caratula" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//generar pdf con la lista de los participantes del proyecto 
const generar_lista_usuarios = async (req, res, next) => {
    try {
        //obtener el id del proyecto para hacer la consulta de la data para generar los pdf 
        const { id } = req.params;
        //antes de generar la cartula y toda ostia tio, primero verificar si hay documentos extras y adjuntarlos al proyecto inicial 
        //primero necesito obtener el primer pdf que seria el documento actual del proyecto de la columna 'url2'
        //devuelve un registro
        const documento_subido_modificado = await pool.query('select * from ver_doc_modificado($1)', [id]);
        //segundo necesito todos los documentos extras con esta en true para juntarlo 
        //devuelve varios
        const documentos_extras = await pool.query('select * from Ver_documentos_extras($1)', [id]);
        //antes de empezar a unir los pdf se debe preguntar si existen o no documentos apra ajuntar 
        //de no existir simplemente se omite este paso 
        let nuevaURLv = '';
        if (documentos_extras.rows.length != 0) {
            const VectorConDocumentos = [];
            VectorConDocumentos.push(documento_subido_modificado.rows[0].p_url_doc);
            for (var i = 0; i < documentos_extras.rows.length; i++) {
                //  Agregar elementos al vector
                VectorConDocumentos.push(documentos_extras.rows[i].r_url_doc);
            }
            //console.log("URLDOCUMENTOS: " + VectorConDocumentos);
            //las url de los documeton estan en el vector
            const pdfDoc = await PDFDocument.create();
            for (const pdfBytes of VectorConDocumentos) {
                //primero obtener el buffer del documento xd 
                const urlDocBase = path.join(__dirname, "../" + pdfBytes)
                const DocBaseBuffer = await fs.readFileSync(urlDocBase);
                const DocBytes = await PDFDocument.load(DocBaseBuffer)
                const copiedPages = await pdfDoc.copyPages(DocBytes, DocBytes.getPageIndices());
                copiedPages.forEach((page) => {
                    pdfDoc.addPage(page);
                });
            }
            //guardar el pdf 
            var nuevaURLv2 = "./uploads/proyectos/" + 'documentomodificado' + Date.now() + '.pdf';
            fs.writeFileSync(nuevaURLv2, await pdfDoc.save());
            //../.
            nuevaURLv = '../.' + nuevaURLv2;
        }
        else {
            console.log('El proyecto no tiene documetos extras' + id);
            nuevaURLv = documento_subido_modificado.rows[0].p_url_doc;
        }
        //no subir niveles, solo actualizar el documento con los nuevos añadidos
        //creo que este me le cambia el estado a todos y solo debe de cambiar a los que tienen true como carta 
        const users2 = await pool.query('call adjuntar_documentos_proyecto_after($1,$2)', [id, nuevaURLv]);




        //primero generar la caratula y guardar la url en un variable para luego juntar todos los documentos 
        const titulo = await pool.query('select * from  titulo_proyecto_pdf($1)', [id]);

        const tituloDelDocumento = titulo.rows[0].r_titulo_proyecto;
        //ruta donde se guardara la caratula        documento_subido.rows[0].p_titulo + Date.now()
        // var nuevaURLv2 = "./uploads/proyectos/" + 'documentomodificado' + Date.now() + '.pdf';
        var fech = Date.now();
        var rutaCaratula = "./uploads/proyectos/Caratula" + Date.now() + '.pdf';
        //esto sive para generar la caratula 

        //const urlFotoEmpresa = path.join(__dirname, "../" + dataProyect.rows[0].r_url_foto_empresa)
        //../../uploads/perfiles/logo_empresa-1690769537460.png
        //esta url debe ser obtenida desde la base de datos solo reemplazar despues del +
        const urlCaratula = path.join(__dirname, "../" + "../../uploads/Galeria/caratula.jpg");
        const browser = await puppeteer.launch();
        const page = await browser.newPage();
        const chunks2 = fs.readFileSync(urlCaratula).toString('base64');


        const content = `
              <!DOCTYPE html>
              <html>
              <head> 
              <style>
              body {
                background-image: url("data:image/jpeg;base64,${chunks2}");
                background-size: cover;
                width: 21cm;
                height: 29.7cm;
                padding: 15mm;
                margin: 0;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
              }
              h1 {
                margin-top: 80px; 
              }
            </style>   
              </head>
              <body>
              <div>
                <h1>${tituloDelDocumento}</h1>
                </div>
              </body>
              </html>
            `;
        //uploads\Galeria\caratula.jpg
        await page.setContent(content);
        await page.pdf({ path: rutaCaratula, format: 'A4', printBackground: true });

        await browser.close();

        //hasta aqui genera la caratula

        //crear pdf con la lista de los usuarios para guardar la url en una variable y juntar todos los documentos
        //lista con los usuarios que desarrollaron el proyecto 
        const usuarios_elaboracion = await pool.query('select * from listado_usuarios_elaboracion($1)', [id]);
        const usuarios_revision = await pool.query('select * from listado_usuarios_revision($1)', [id]);
        const usuarios_publicacion = await pool.query('select * from listado_usuarios_publicacion($1)', [id]);
        const users = await pool.query('select * from  titulo_proyecto_pdf($1)', [id]);
        const datos_empresa = await pool.query('select * from  encabezado_empresa_pdf()');
        //const tituloDelDocumento = users.rows[0].r_titulo_proyecto;
        const urlFotoEmpresa = path.join(__dirname, "../" + datos_empresa.rows[0].r_url_logo)
        console.log(urlFotoEmpresa);
        const chunks = fs.readFileSync(urlFotoEmpresa).toString('base64');
        var html = fs.readFileSync("SRC/controllers/Proyects/caratula.html", "utf8");
        console.log("file://C:/Users/casti/OneDrive/Escritorio/BackendSGD/uploads/perfiles/logo_empresa-1690769537460.png");
        //ruta donde se guardara el listado            documento_subido.rows[0].p_titulo + Date.now()
        const rutaListado = "./uploads/proyectos/" + 'Listado' + Date.now() + '.pdf';
        var options = {
            format: "A4",
            orientation: "portrait",
            border: "10mm",
            localUrlAccess: true,
        };
        var document = {
            html: html,
            data: {
                users: usuarios_elaboracion.rows,
                users2: usuarios_revision.rows,
                users3: usuarios_publicacion.rows,
                titulo: tituloDelDocumento,
                chunks: chunks,
                Empresa: datos_empresa.rows[0].r_nombre_empresa
            },
            path: rutaListado,
            type: "",
        };
        await pdf.create(document, options);

        //ahora juntar la caratula, la lista de usuarios y el documento modificado del proyecto para hacerlo uno solo xd 
        //primero obtener el pdf modificado de la base de datos 
        const documento_subido = await pool.query('select * from ver_doc_modificado($1)', [id]);
        //crear un vector que almacene todas las rutas de los documentos que se quieren unir 
        const VectorConDocumentos = [];
        //los demas documentos que se desean subir 
        //            nuevaURL = '../.' + nuevaURL2;
        VectorConDocumentos.push('../.' + rutaCaratula);
        VectorConDocumentos.push('../.' + rutaListado);
        //el siguiente push tiene que ser sobre las contraportadas 
        const contraportadas = await pool.query('select * from Ver_contraportadas($1)', [id]);
        if (contraportadas.rows.length != 0) {
            console.log("Hay contraportadas");
            for (var i = 0; i < contraportadas.rows.length; i++) {
                //  Agregar elementos al vector
                VectorConDocumentos.push(contraportadas.rows[i].r_url_doc);
            }
        }
        VectorConDocumentos.push(documento_subido.rows[0].p_url_doc);
        //ahora unir los documentos en un solo pdf
        const pdfDoc = await PDFDocument.create();
        for (const pdfBytes of VectorConDocumentos) {
            //primero obtener el buffer del documento xd 
            const urlDocBase = path.join(__dirname, "../" + pdfBytes)
            const DocBaseBuffer = await fs.readFileSync(urlDocBase);
            const DocBytes = await PDFDocument.load(DocBaseBuffer)
            const copiedPages = await pdfDoc.copyPages(DocBytes, DocBytes.getPageIndices());
            copiedPages.forEach((page) => {
                pdfDoc.addPage(page);
            });
        }
        //guardar el pdf 
        //cuando se envie a la base de datos se tiene que enviar con '../.' + URL 
        //const rutaListado = "./uploads/proyectos/" + 'Listado' + Date.now() + '.pdf';
        const nuevaURL = "./uploads/proyectos/" + 'NUEVO' + Date.now() + '.pdf';
        fs.writeFileSync(nuevaURL, await pdfDoc.save());

        //tomar el primer doc con todos los encabezados

        const urlArchivos = path.join(__dirname, "../" + nuevaURLv)
        const buffer = await fs.readFileSync(urlArchivos);
        const pdfDocEncabezados = await PDFDocument.load(buffer)
        console.log("Paguinas del doc" + pdfDocEncabezados.getPages().length);
        //const pages = pdfDocEncabezados.getPages();

        //mes de prueba nomas sin base de gatos jijiji ja xd setzo skere modo diablo
        const currentDate = new Date();
        const currentMonth = currentDate.getMonth() + 1;
        var Mes = currentMonth === 1 ? "Enero" : currentMonth === 2 ? "Febrero" : currentMonth === 3 ? "Marzo" : currentMonth === 4 ? "Abril" : currentMonth === 5 ? "Mayo" : currentMonth === 6 ? "Junio" : currentMonth === 7 ? "Julio" : currentMonth === 8 ? "Agosto" : currentMonth === 9 ? "Septiembre" : currentMonth === 10 ? "Octubre" : currentMonth === 11 ? "Noviembre" : "Diciembre";
        const Anio = currentDate.getFullYear();
        //pdf con todo las paguinas 
        //nuevaURL         const urlArchivos = path.join(__dirname, "../" + documento)
        var nueval222 = "../." + nuevaURL;
        const urlArchivosTodo = path.join(__dirname, "../" + nueval222)
        const buffertodo = await fs.readFileSync(urlArchivosTodo);
        const pDFTODO = await PDFDocument.load(buffertodo)
        console.log("Paguinas del doc" + pDFTODO.getPages().length);
        const pages = pDFTODO.getPages();
        //paguina para poner la enumeracion 
        var NumPag = (pDFTODO.getPages().length - pdfDocEncabezados.getPages().length) + 1;
        console.log("Paguina donde empieza la enumaracion: " + NumPag);
        //consultar a la base de datos el encabezado del proyecto con el codigo y la version del proyecto 
        const dataProyect = await pool.query('select * from pro_encabezado($1)', [id]);

        let fontsize = 10
        const font = await pDFTODO.embedFont(StandardFonts.HelveticaBold);
        const opacidad = 0.6

        var numerototal = pDFTODO.getPages().length;
        for (i = 0; i < pDFTODO.getPages().length; i++) {
            var numero_paguina = i + 1;
            if (i >= NumPag - 1) {
                const pageActually = pages[i]
                const { width, height } = pageActually.getSize()
                //Numero de pagina
                pageActually.drawText(numero_paguina + " de " + numerototal, {
                    x: 460,
                    y: height / 2 + 305,
                    size: fontsize,
                    opacity: opacidad

                })
                pageActually.drawText(Mes + " " + Anio.toString(), {
                    x: 300,
                    y: height / 2 + 305,
                    size: fontsize,
                    opacity: opacidad

                })
                pageActually.drawText(dataProyect.rows[0].r_codigo, {
                    x: 165,
                    y: height / 2 + 345,
                    size: fontsize,
                    opacity: opacidad

                })
                pageActually.drawText(dataProyect.rows[0].r_version, {
                    x: 170,
                    y: height / 2 + 305,
                    size: fontsize,
                    font: font,
                    opacity: opacidad

                })
            }

        }
        // const rutaCaratula = "./uploads/proyectos/" + 'Caratula' + Date.now() + '.pdf';
        //tituloDelDocumento
        const rutaNuevoDOc = "./uploads/proyectos/" + tituloDelDocumento + Date.now() + '.pdf';
        fs.writeFileSync(rutaNuevoDOc, await pDFTODO.save());
        //aqui guardar el documento en la base de datos y cambiar todas las portadas en false 
        var ur = "../." + rutaNuevoDOc;
        const guardar_doc = await pool.query('call aceptar_documento($1,$2)', [ur, id]);



        return res.status(200).json({ message: "Se preparo el documento" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}
//subir una contraportada 
const subir_contraportada = async (req, res, next) => {
    try {
        const { id } = req.body;
        const { descripcion } = req.body;
        const { file } = req;
        const documento = `${ipFileServer}${file?.filename}`;
        console.log(documento);
        const users = await pool.query('call insertar_contra_portadas($1,$2,$3)', [documento, id, descripcion]);
        //console.log(users);
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

//funcion para recibir un array buffer y convertirlo en pdf para el editor de texto
const Convertir_Editor_a_pdf = async (req, res, next) => {
    try {
        const { jsPDF } = require('jspdf');

        const { id_proyecto, array_buffer } = req.body;
        const doc = new jsPDF({
            orientation: "portrait",
            unit: "mm",
            format: "a4",
        });
        console.log("Este es el array buffer del pdf " + array_buffer)
        // Convierte el buffer recibido en un formato Uint8Array
        const uint8Array = new Uint8Array(array_buffer);
        // Carga el contenido Uint8Array en el documento jsPDF
        doc.loadFile(uint8Array);

        // Guarda el PDF en el sistema de archivos
        const outputPath = 'output.pdf';
        fs.writeFileSync(outputPath, doc.output());
        return res.status(200).json({ message: "se subio el archivo" });
    } catch (error) {
        console.log(error)
        return res.status(404).json({ message: error.message });
    }
}

//fucion para listar los proyectos publicados para realizarles reformas 
const proyectos_publicados_para_reformas = async (req, res, next) => {
    try {
        const users = await pool.query('select * from proyectos_publicados_reformas()');
        console.log(users);
        return res.status(200).json(users.rows);
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}
//funcion para iniciar una reforma de algun proyecto y subir su alcance xdxdxd skere modo diablo
let ipFileServerAlcance = "../../uploads/alcances/";
const iniciar_reforma = async (req, res, next) => {
    try {
        const { id_proyecto } = req.body;
        const { file } = req;
        const { p_id_area_reforma } = req.body;
        const { descripcion } = req.body;

        const documento = `${ipFileServerAlcance}${file?.filename}`;
        //let ext = path.extname(file);
        console.log("Datos recibidos por el frontend");
        console.log("Id proyecto" + id_proyecto);
        console.log("p_id_area_reforma" + p_id_area_reforma);
        console.log("descripcion" + descripcion);
        console.log(documento);

        //verificar que los datos sean ingresados de manera correcta sjsjs skere modo skere 
        if (documento === '../../uploads/alcances/undefined')
            return res.status(404).json({ message: "Documento no legible" });
        //aqui enviar a la base de datos para que haga el proceso xdxd skere modo diablo
        const users = await pool.query('call iniciar_reforma($1,$2,$3,$4)', [id_proyecto, documento, p_id_area_reforma, descripcion]);
        console.log(users);
        return res.status(200).json({ message: "Se realizó la reforma" });
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}




//Para cargar las veriones que tiene ese proyectto en el combobox
const ver_proyectos_publicados_versiones = async (req, res, next) => {
    try {
        const { idproyecto } = req.params;
        const users = await pool.query('select * from list_combobox_version($1)', [idproyecto]);
        return res.status(200).json(users.rows);
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

//Ver pdf solo enviar la URL del doc
const ver_pdf_url_version = async (req, res) => {
    try {
        const { id } = req.params;
        //console.log(id);
        const users = await pool.query('select * from Ver_Documento_version($1)', [id]);
        const urlArchivos = path.join(__dirname, "../" + users.rows[0].r_url_doc)
        //console.log(users.rows[0].r_url_doc);
        var data = fs.readFileSync(urlArchivos);
        console.log(data);
        res.contentType("application/pdf");
        res.send(data);
    } catch (error) {
        return res.status(404).json({ message: error.message })
    }
};



//funcion para firmar documentos electronicamente 
//const { PDFDocument, PDFHexString, PDFArray, } = require('pdf-lib');
//const { PDFDocument, rgb, StandardFonts } = require('pdf-lib');
const forge = require('node-forge'); // Librería para trabajar con P12
const signer = require('node-signpdf');

const firmar_documento_p12 = async (req, res, next) => {
    try {
        /*
        // Ruta al archivo PDF que deseas firmar
        const pdfFilePath = path.join(__dirname, 'AVAL Docente.pdf');
        //contra del .p12 --> Veliz1234@
        // Ruta al archivo P12
        const p12FilePath = path.join(__dirname, '_JINA RUTH VELIZ MENDEZ 200323182939.p12');
        const p12Password = 'Veliz1234@';
 
        //verificar los archivos 
 
 
        // Cargar el archivo P12 utilizando la librería node-forge-p12
        const p12Buffer = fs.readFileSync(p12FilePath);
        //const p12 = new P12(p12Buffer, p12Password);
        const p12Asn1 = fs.readFileSync(p12FilePath, 'binary');
        var p12Asn2 = forge.asn1.fromDer(p12Asn1);
        var p12 = forge.pkcs12.pkcs12FromAsn1(p12Asn2, p12Password);
        var certBags = p12.getBags({ bagType: forge.pki.oids.certBag });
        var pkeyBags = p12.getBags({ bagType: forge.pki.oids.pkcs8ShroudedKeyBag });
 
        // Verifica si puedes obtener información del certificado y la clave privada
        console.log('Certificado:', p12);
        console.log('certBags:', certBags);
        console.log('pkeyBags:', pkeyBags);
 
 
        // Crear un nuevo objeto PDFDocument
        const pdfBytes = fs.readFileSync(pdfFilePath);
        signer.SignPdf
        const pdfDoc = await PDFDocument.load(pdfBytes);
        const signedPdf = new signer.SignPdf(
            fs.readFileSync(path.join(__dirname, 'AVAL Docente.pdf')),
            fs.readFileSync(path.join(__dirname, '_JINA RUTH VELIZ MENDEZ 200323182939.p12')),
 
        );
 
        console.log(signedPdf);
            */

        //PROBANDO CON EL SCRIPT DE PYTHON PORQUE ESTA WEBADA NO FUNCIONA EN NODE JS
        const { PythonShell } = require('python-shell');

        // Configura las opciones para la ejecución del script Python
        const options = {
            mode: 'text',
            pythonOptions: ['-u'], // Deshabilita el almacenamiento en búfer de la salida
            scriptPath: __dirname, // Ruta al directorio del script Python
            args: ['funcion_a'] // Nombre de la función de Python que deseas llamar
        };

        // Crea una instancia de PythonShell con las opciones
        const pythonShell = new PythonShell('primer.py', options);

        // Escucha la salida del script Python
        pythonShell.on('message', (message) => {
            console.log(`Salida de la función de Python: ${message}`);
        });

        // Maneja cualquier error que ocurra durante la ejecución del script Python
        pythonShell.on('error', (err) => {
            console.error('Error al ejecutar el script de Python:', err);
        });

        // Finaliza la instancia de PythonShell cuando termine
        pythonShell.end((err, code, signal) => {
            if (err) {
                console.error('Error al finalizar el script de Python:', err);
            }
            console.log('Script de Python finalizado con código de salida', code);
        });


        return res.status(200).json("Se firmo el documento mediante el p12");
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}

//Funcion para cargar los datos del alcance si es reforma
const ver_docs_alcance = async (req, res) => {
    try {
        const { id } = req.params;
        const users = await pool.query('select * from ver_docs_alcance($1)', [id]);
        return res.status(200).json(users.rows);
    } catch (error) {
        console.log(error);
        return res.status(404).json({ message: error.message });
    }
}


//Funcion para cargar el pdf del alcance si es reforma
const ver_pdf_alcance = async (req, res) => {
    try {
        const { id } = req.params;
        //console.log(id);
        const users = await pool.query('select * from ver_pdf_alcance($1)', [id]);
        const urlArchivos = path.join(__dirname, "../" + users.rows[0].d_url)
        console.log(users.rows[0].d_url);
        var data = fs.readFileSync(urlArchivos);
        console.log(data);
        res.contentType("application/pdf");
        res.send(data);
    } catch (error) {
        return res.status(404).json({ message: error.message });

    }
}
//funcion para editar los datos de un proyecto, como el titulo, prefijo y su visibilidad
const editar_proyecto = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { p_titulo, p_prefijo_nuevo, p_visibilidad } = req.body;
        const users = await pool.query('call editar_proyecto_datos($1,$2,$3,$4)', [p_titulo, p_prefijo_nuevo, id, p_visibilidad]);
        console.log(users);
        return res.status(200).json({ message: "Se actualizó los datos del proyecto" });
    } catch (error) {
        return res.status(404).json({ message: error.message });
    }
}

module.exports = {
    crear_proyecto,
    crear_categoria,
    proyectos_areas,
    all_categorias,
    roles_proyecto,
    subir_pdf,
    documentos_proyectos,
    ver_pdf,
    list_categorias,
    editar_categoria,
    estado_categoria,
    guias_proyectos,
    subir_guia,
    download_guia,
    ver_flujo_proyecto,
    borradores_proyecto,
    proyect_data,
    niveles_estado,
    ver_flujo_proyecto_nivel2,
    subir_primer_nivel,
    id_doc,
    subir_level,
    publicar_doc,
    proyectos_publicados,
    deshabilitar_flujo,
    rechazar_proyecto,
    historial_proyecto,
    ver_flujo_rechazado,
    ver_flujo_historial,
    ver_documentos_extras,
    ver_pdf_url,
    subir_pdf_extra,
    combinar_pdfs,
    ver_pdf_2,
    participantes_actuales_proyecto,
    participantes_sin_proyectos,
    agregar_usuario_proyecto,
    expulsar_usuario_proyecto,
    generar_caratula,
    generar_lista_usuarios,
    ver_documentos_contraportadas,
    subir_contraportada,
    Convertir_Editor_a_pdf,
    proyectos_publicados_para_reformas,
    iniciar_reforma,
    firmar_documento_p12,
    ver_proyectos_publicados_versiones,
    ver_pdf_url_version,
    ver_docs_alcance,
    ver_pdf_alcance
};
