# Multistage build to compile TimelineJS and run the Flask website
FROM node:18 AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --production
COPY . .
RUN npm run dist

FROM python:3.10-slim
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY website ./website
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ENV FLASK_SETTINGS_MODULE=core.settings.loc
EXPOSE 8000
CMD ["python", "website/app.py", "-p", "8000"]
