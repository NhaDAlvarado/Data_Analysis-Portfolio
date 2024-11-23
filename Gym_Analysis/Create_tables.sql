CREATE TABLE gym_members_exercise_tracking (
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Weight_kg FLOAT NOT NULL,
    Height_m FLOAT NOT NULL,
    Max_BPM INT NOT NULL,
    Avg_BPM INT NOT NULL,
    Resting_BPM INT NOT NULL,
    Session_Duration_hours FLOAT NOT NULL,
    Calories_Burned FLOAT NOT NULL,
    Workout_Type VARCHAR(50) NOT NULL,
    Fat_Percentage FLOAT NOT NULL,
    Water_Intake_liters FLOAT NOT NULL,
    Workout_Frequency_days_per_week INT NOT NULL,
    Experience_Level INT NOT NULL,
    BMI FLOAT NOT NULL
);

select * from gym_members_exercise_tracking
