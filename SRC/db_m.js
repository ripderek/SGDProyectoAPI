//aqui va lo de moongosse osea mongoDB
const mongoose =require ('mongoose');

// db.js

const Connection = async (username = 'aherreras3', password = 'Febrero2002') => {
  const dbUrl = `mongodb://${username}:${password}@ac-fqed7bt-shard-00-00.npmop0q.mongodb.net:27017,ac-fqed7bt-shard-00-01.npmop0q.mongodb.net:27017,ac-fqed7bt-shard-00-02.npmop0q.mongodb.net:27017/docsgoogle?ssl=true&replicaSet=atlas-10kg5i-shard-0&authSource=admin&retryWrites=true&w=majority`;

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

