class Produto {
  int codProduto;
  String descProduto;
  int codCategoria;
  double valor;
  String detalhes;
  double percDesconto;
  List<Imagens> imagens;

  Produto(
      {this.codProduto,
        this.descProduto,
        this.codCategoria,
        this.valor,
        this.detalhes,
        this.percDesconto,
        this.imagens});

  Produto.fromJson(Map<String, dynamic> json) {
    codProduto = json['codProduto'];
    descProduto = json['descProduto'];
    codCategoria = json['codCategoria'];
    valor = json['valor'] == null? 0 : double.parse(json['valor'].toString());
    detalhes = json['detalhes'];
    percDesconto = json['percDesconto'] == null? 0 : double.parse(json['percDesconto'].toString());
    if (json['imagens'] != null) {
      imagens = new List<Imagens>();
      json['imagens'].forEach((v) {
        imagens.add(new Imagens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codProduto'] = this.codProduto;
    data['descProduto'] = this.descProduto;
    data['codCategoria'] = this.codCategoria;
    data['valor'] = this.valor;
    data['detalhes'] = this.detalhes;
    data['percDesconto'] = this.percDesconto;
    if (this.imagens != null) {
      data['imagens'] = this.imagens.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Produto{codProduto: $codProduto, descProduto: $descProduto, codCategoria: $codCategoria, valor: $valor, detalhes: $detalhes, percDesconto: $percDesconto, imagens: $imagens}';
  }
}

class Imagens {
  int codProdutoImagem;
  int codProduto;
  String descImagem;
  String url;
  String imagem;

  Imagens(
      {this.codProdutoImagem,
        this.codProduto,
        this.descImagem,
        this.url,
        this.imagem});

  Imagens.fromJson(Map<String, dynamic> json) {
    codProdutoImagem = json['codProdutoImagem'];
    codProduto = json['codProduto'];
    descImagem = json['descImagem'];
    url = json['url'];
    imagem = json['imagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codProdutoImagem'] = this.codProdutoImagem;
    data['codProduto'] = this.codProduto;
    data['descImagem'] = this.descImagem;
    data['url'] = this.url;
    data['imagem'] = this.imagem;
    return data;
  }

  @override
  String toString() {
    return 'Imagens{codProdutoImagem: $codProdutoImagem, codProduto: $codProduto, descImagem: $descImagem, url: $url, imagem: $imagem}';
  }


}
