FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime
RUN apt-get update

RUN apt-get update && apt-get install -y \
  curl \
  wget \
  vim \
  unzip \
  git \
  build-essential \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY scripts/env.yml env.yml

RUN conda update conda
RUN conda env create --file env.yml
RUN echo "source activate tabert" > ~/.bashrc
ENV PATH /opt/conda/envs/tabert/bin:$PATH


#RUN python -m spacy download en_core_web_sm

# RUN jupyter nbextension enable --py widgetsnbextension
RUN pip install torch-scatter==2.0.5+cu101 -f https://pytorch-geometric.com/whl/torch-1.5.0.html
RUN pip install --editable=git+https://github.com/huggingface/transformers.git@372a5c1ceec49b52c503707e9657bfaae7c236a0#egg=pytorch_pretrained_bert

WORKDIR /tabert

CMD ["jupyter", "notebook", "--port=8002", "--no-browser", "--ip=0.0.0.0", "--allow-root"]