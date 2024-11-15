# go_student

**Step 1 : Execute the docker-compose.yaml to setup containers having postgres DB and pgadmin.**
         docker-compose -f docker-compose.yaml up -d                                                                                                    
         
**Step 2 : Execute the ingest_data.py script to ingest data from CSV files to postgres.**                                                           
           python3 ingest_data.py
         
**Step 3 : Setup DBT with postgres connector.**                                                                                                        
           pip install dbt-postgres

         
