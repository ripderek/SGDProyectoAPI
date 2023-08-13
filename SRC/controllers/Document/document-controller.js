const Document = require('../../../schema/documentshema') 
/*const getDocument = async (id) => {
    if (!id) return null;

    try {
        const document = await Document.findById(id);

        if (document) {
            return document;
        } else {
            return await Document.create({ _id: id, data: "" });
        }
    } catch (error) {
        // Manejo de errores aquí, por ejemplo: console.error(error);
        throw error;
    }
};*/
const getDocument = async (id) => {
    if (!id) return { data: "" }; // Valor por defecto en caso de id no válido

    try {
        const document = await Document.findById(id);

        if (document) {
            return document;
        } else {
            return await Document.create({ _id: id, data: "" });
        }
    } catch (error) {
        // Manejo de errores aquí, por ejemplo: console.error(error);
        throw error;
    }
};

const updateDocument = async (id, data) => {
    try {
        const updatedDocument = await Document.findByIdAndUpdate(id, { data }, { new: true });

        return updatedDocument;
    } catch (error) {
        // Manejo de errores aquí, por ejemplo: console.error(error);
        throw error;
    }
};

module.exports = {
    getDocument,
    updateDocument
};
