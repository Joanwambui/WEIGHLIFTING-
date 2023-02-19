SELECT *
FROM workout
ORDER BY workout_id
	OFFSET 0 ROWS
	FETCH NEXT 3ROWS ONLY;

SELECT *
FROM lifts
ORDER BY workout_id
	OFFSET 0 ROWS
	FETCH NEXT 3ROWS ONLY;

SELECT *
FROM exercises
ORDER BY exercise_id
	OFFSET 0 ROWS
	FETCH NEXT 3ROWS ONLY;

SELECT *
FROM categories
ORDER BY category_id
	OFFSET 0 ROWS
	FETCH NEXT 3ROWS ONLY;

-- JOIN Workout Table and Lifts Table by workout_id and created a new column to calculate the estimated 1 Rep Max
SELECT workout.workout_id, 
workout.workout_date,
lifts.exercise_id,
lifts.weight_lbs,
lifts.reps,
lifts.weight_lbs/(1.0278 - (0.0278 * lifts.reps)) AS est_one_rep_max
FROM workout
INNER JOIN lifts
ON workout.workout_id = lifts.workout_id
ORDER BY workout.workout_id;


-- Show the Exercise and Category for distinct categories
SELECT DISTINCT lifts.exercise_id,exercises.exercise_name,exercises.category_id,categories.category_name
FROM lifts
JOIN exercises
ON lifts.exercise_id=exercises.exercise_id
JOIN categories
ON exercises.category_id=categories.category_id

-- Show the Exercise and Category for each lift entry
SELECT 
    lifts.workout_id,
    exercises.exercise_id, 
    exercises.exercise_name, 
    categories.category_id, 
    categories.category_name
FROM exercises
LEFT JOIN categories
ON exercises.category_id = categories.category_id
LEFT JOIN lifts
ON exercises.exercise_id = lifts.exercise_id
ORDER BY workout_id


-- Average Weight per Lift

SELECT 
	AVG(lifts.weight_lbs) AS avg_weight_lbs, 
	exercises.exercise_name 
FROM lifts
INNER JOIN exercises
ON lifts.exercise_id = exercises.exercise_id
GROUP BY exercises.exercise_name


-- Maximum Weight per Lift
SELECT MAX(lifts.weight_lbs) AS avg_weight_lbs, 
exercises.exercise_name 
FROM lifts
INNER JOIN exercises
ON lifts.exercise_id = exercises.exercise_id

-- How many exercises I did per workout
SELECT 
	COUNT(lifts.exercise_id) AS number_of_exercises,
    	workout.workout_date
FROM workout
	INNER JOIN lifts
ON workout.workout_id = lifts.workout_id
GROUP BY workout_date
ORDER BY workout_date

-- Avg Weight per Workoutdate
SELECT 
	AVG(lifts.weight_lbs) AS avg_weight,
    	workout.workout_date
FROM workout
INNER JOIN lifts
ON workout.workout_id = lifts.workout_id
GROUP BY workout_date
ORDER BY workout_date

-- Total Volume per Date

SELECT 
SUM(lifts.volume_lbs) AS total_volume,
  workout.workout_date
FROM workout
 	INNER JOIN lifts
	ON workout.workout_id = lifts.workout_id
GROUP BY workout.workout_date
ORDER BY workout.workout_date;

--Total volume per exercise 
SELECT
SUM(
      CASE
        WHEN lifts.exercise_id = '1' THEN lifts.volume_lbs
        WHEN lifts.exercise_id = '2' THEN lifts.volume_lbs
        WHEN lifts.exercise_id = '3' THEN lifts.volume_lbs
        WHEN lifts.exercise_id = '4' THEN lifts.volume_lbs
        WHEN lifts.exercise_id = '5' THEN lifts.volume_lbs
        END 
  ) AS total_volume,
  exercises.exercise_name
FROM lifts
    INNER JOIN exercises
    ON lifts.exercise_id = exercises.exercise_id
GROUP BY exercises.exercise_name;

-- Average Repetitions per Workout Date
SELECT 
	AVG(lifts.reps) AS repetitions,
    workout.workout_date
FROM workout
INNER JOIN lifts
ON workout.workout_id = lifts.workout_id
GROUP BY workout_date
ORDER BY workout_date

-- Total count for each category type 
SELECT 
    COUNT( CASE 
        WHEN categories.category_id = '1' THEN 1
        WHEN categories.category_id = '2' THEN 1
        WHEN categories.category_id = '3' THEN 1
        WHEN categories.category_id = '4' THEN 1
        END
        ) AS category_count,
     categories.category_name
FROM exercises
LEFT JOIN categories
ON exercises.category_id = categories.category_id
LEFT JOIN lifts
ON exercises.exercise_id = lifts.exercise_id
GROUP BY categories.category_name
ORDER BY categories.category_name