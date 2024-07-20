# ベースイメージとしてRubyを使用
FROM ruby:3.0.7

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    nodejs \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y yarn \
    && rm -f /usr/bin/yarn \
    && ln -s /usr/lib/node_modules/yarn/bin/yarn.js /usr/bin/yarn

# 作業ディレクトリを設定
WORKDIR /myapp

# Node.jsとYarnのインストール
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# GemfileとGemfile.lockをコピーし、bundle installを実行
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# package.jsonとyarn.lockをコピーし、yarn installを実行
COPY package.json /myapp/package.json
COPY yarn.lock /myapp/yarn.lock
RUN yarn install

# アプリケーションのソースコードをコピー
COPY . /myapp

# Webpackerをインストール
RUN bundle exec rails webpacker:install

# アセットをプリコンパイル
RUN bundle exec rails assets:precompile

# ポート4000を公開
EXPOSE 4000

# アプリケーションを起動
CMD ["rails", "server", "-b", "0.0.0.0"]