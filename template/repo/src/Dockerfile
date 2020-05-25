FROM amsterdam/python:3.7-buster
MAINTAINER datapunt@amsterdam.nl

# Install GOB_TEMPLATE_PYTHON_MODULE_NAME in /app folder
WORKDIR /app

# Install required Python packages
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

# Copy gobimport module
COPY GOB_TEMPLATE_PYTHON_MODULE_NAME GOB_TEMPLATE_PYTHON_MODULE_NAME

CMD ["python", "-m", "GOB_TEMPLATE_PYTHON_MODULE_NAME"]
