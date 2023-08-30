//aqui va lo de moongosse osea mongoDB
const mongoose =require ('mongoose');
const Connection = async (username = 'aherreras3', password = 'Febrero2002') => {
  const dbUrl = `mongodb://${username}:${password}@ac-kvkwlkz-shard-00-00.orqic1z.mongodb.net:27017,ac-kvkwlkz-shard-00-01.orqic1z.mongodb.net:27017,ac-kvkwlkz-shard-00-02.orqic1z.mongodb.net:27017/PROYECTFINAL3?ssl=true&replicaSet=atlas-rwnvpp-shard-0&authSource=admin&retryWrites=true&w=majority`;

  try {
    await mongoose.connect(dbUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('Database connected successfully');
  }catch (error) {
    if (error instanceof mongoose.MongooseError) {
      console.error('MongooseError:', error.message);
    } else {
      console.error('Unknown Error:', error.message);
    }
}
};

module.exports = Connection;

