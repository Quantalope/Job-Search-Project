# **HuskiesJobSearch**

## Prerequisites

- Running MySQL Server
- Python 3.x
- Jupyter Notebook
- Faker

## Setup Instructions

1. Clone the repo.
2. Install dependencies.
3. Start MySQL server (if not already running).
4. Create a .env (using .env.example as an example) and input your connection password.
5. Run the setup notebook titled 'build_database.ipynb'
6. Verify setup was successful.

## Database Schema

The database (HuskiesJob) includes these tables:

- Users
- Company
- Positions
- Application
- Skills
- Position_Skill
- User_Skill
