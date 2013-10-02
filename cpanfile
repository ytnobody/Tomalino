on 'test' => sub {
    requires 'Test::More' => 0;
};
requires 'Nephia' => 0;
requires 'NephiaX::Auth::Twitter';
requires 'Cache::Cache' => 0;
requires 'Plack::Middleware::CSRFBlock' => 0;
requires 'DBIx::Sunny';
requires 'Config::Micro';
