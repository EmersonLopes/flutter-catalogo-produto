class Categoria {
  int codCategoria;
  String descCategoria;
  String imagem;
  String url;

  Categoria({this.codCategoria, this.descCategoria, this.imagem, this.url});

  Categoria.fromJson(Map<String, dynamic> json) {
    codCategoria = json['codCategoria'];
    descCategoria = json['descCategoria'];
    imagem = json['imagem'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codCategoria'] = this.codCategoria;
    data['descCategoria'] = this.descCategoria;
    data['imagem'] = this.imagem;
    data['url'] = this.url;
    return data;
  }

  @override
  String toString() {
    return 'Categoria{codCategoria: $codCategoria, descCategoria: $descCategoria, imagem: $imagem, url: $url}';
  }


}
