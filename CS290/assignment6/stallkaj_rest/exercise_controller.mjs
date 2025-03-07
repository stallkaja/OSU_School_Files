import * as exercises from './exercise_model.mjs';  
import express from 'express';
const app = express();
const PORT = 3000;
// Also allows parsing of req.body.
app.use(express.json());


// Create a new exercise using a post request
app.post('/exercises', (req, res) => {

    exercises.createExercise(
      req.body.name,
      req.body.reps,
      req.body.weight,
      req.body.unit,
      req.body.date
    )
      .then(exercise => {
        res.status(201).json(exercise);
      })
      .catch(error => {
        console.error(error);
        res.status(400).json({ Error: 'Request failed' })
      });
  
  });

// read exercises using a get request
app.get('/exercises', (_, res) => {
    exercises.findExercises({}, '', 0)
      .then(exercise => { res.json(exercise) })   // default status code is 200
      .catch(error => { 
        console.error(error) 
        res.status(400).json( { Error: 'Request failed' } )
      });
  });

//replace an exercsise using a put request
app.put('/exercises/:id', (req, res) => {
    const args = {
      _id: req.params.id,
      name: req.body.name,
      reps: req.body.reps,
      weight: req.body.weight,
      unit: req.body.unit,
      date: req.body.date
    }
  
    exercises.replaceExercise(args)
      .then(nModified => {
        if (nModified === 1){
          res.json(args) 
        } else {
          res.status(404).json({ Error: 'Resource not found' })
        }
      })
      .catch(error => {
        console.error(error)
        res.status(400).json({ Error: 'Request failed' })
      });
  });


//delete and exercise
app.delete('/exercises/:id', (req, res) => {
    exercises.deleteExercise(req.params.id)
      .then(deletedCount => {
        if (deletedCount === 1) {
          res.status(204).send()
        } else {
          res.status(404).json({ Error: 'Resource not found' })
        }
      })
      .catch(error => {
        console.error(error)
        res.status(400).json({ Error: 'Request failed' })
      });
  
  });
  
  
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
  });

