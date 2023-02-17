FROM gardendev/garden:0.12.51-buster as devcontainer

# Base, including any build dependencies
FROM python:3.11.2-alpine3.17 as builder

# Install PDM
RUN pip install --no-cache-dir pdm==2.4.5

# Copy project scaffolding
COPY pyproject.toml pdm.lock /

RUN mkdir __pypackages__ && pdm install --prod --no-lock --no-editable

FROM python:3.11.2-alpine3.17 as production

ENV PYTHONPATH=/home/appuser/pkgs

RUN adduser -S appuser -h /home/appuser

COPY --from=builder /__pypackages__/3.11/lib /home/appuser/pkgs
COPY --from=builder /__pypackages__/3.11/bin /usr/local/bin

COPY app /home/appuser/app/

CMD [ "uvicorn", "app.main:app", "--host", "0.0.0.0" ]
