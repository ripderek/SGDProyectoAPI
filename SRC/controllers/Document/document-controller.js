const Document  = require('../../../schema/documentshema');

// Función para guardar el contenido del editor en MongoDB
const saveDocument = async (id_proyecto, content) => {
  try {
    const existingDocument = await Document.findOne({ id_proyecto });

    if (existingDocument) {
      existingDocument.content = content;
      await existingDocument.save();
    } else {
      const newDocument = new Document({
        id_proyecto,
        content,
      });
      await newDocument.save();
    }
  } catch (error) {
    console.error('Error saving document:', error);
  }
};

// Función para obtener el contenido del editor desde MongoDB
const getDocumentContent = async (id_proyecto) => {
  try {
    const document = await Document.findOne({ id_proyecto });
    return document ? document.content : null;
  } catch (error) {
    console.error('Error getting document content:', error);
    return null;
  }
};

module.exports = {
  saveDocument,
  getDocumentContent,
};
