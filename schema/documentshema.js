const mongoose = require ("mongoose");

const documentshema = mongoose.Schema({
    _id:{
        type: String,
        required: true
    },
    data:{
        type: Object,
        required: true
    }
});

const document = mongoose.model('document', documentshema);

module.exports = document;