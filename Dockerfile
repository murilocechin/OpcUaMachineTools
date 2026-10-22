FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir "asyncua>=2.0.1"

COPY MachineDemoServer/Python/ /app/

# Listen on the container network interface so published ports are reachable.
RUN sed -i 's|opc.tcp://127.0.0.1:50000|opc.tcp://0.0.0.0:50000|' ReplayConfiguration.xml

EXPOSE 50000

CMD ["python", "-u", "PythonMachineDemoServer.py"]
