# Stage 1 : Build stage
FROM python:3.10 AS build

WORKDIR /app

#copy the requirement.txt file from flask_app folder
COPY flask_app/requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt


# Copy the application code and model files
COPY flask_app/ /app/
COPY models/vectorizer.pkl /app/models/vectorizer.pkl

# Download only the necessary NLTK data
RUN python -m nltk.downloader stopwords wordnet

# stage 2: Final stage
FROM python:3.10-slim AS final

WORKDIR /app

#Copy only the necessary files from the build stage
COPY --from=build /app /app

#Expose the appication port
EXPOSE 5000

#Set the command to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "120", "app:app"]

