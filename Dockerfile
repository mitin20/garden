FROM gardendev/garden:0.12.51-buster as devcontainer

# Base, including any build dependencies
FROM python:3.11-alpine as builder

# Install PDM
RUN pip install -U pip setuptools wheel
RUN pip install pdm

# Copy project scaffolding
COPY pyproject.toml pdm.lock /project/
COPY app/ /project/app

WORKDIR /project
RUN mkdir __pypackages__ && pdm install --prod --no-lock --no-editable

FROM builder as production

ENV PYTHONPATH=/project/pkgs

COPY --from=builder /project/__pypackages__/3.11/lib /project/pkgs
COPY --from=builder /project/__pypackages__/3.11/bin /usr/local/bin

CMD [ "uvicorn", "app.main:app", "--host", "0.0.0.0" ]