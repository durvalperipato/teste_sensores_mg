/*Para modificar o cabeçalho apenas inserir/alterar/excluir os blocos conforme 
a estrutura do nível do Map -> bloco(number) -> titles(title:flex) -> subtitles(index:{flex,title1, title2, ...})*/

import 'package:flutter/cupertino.dart';

TextEditingController riaController = TextEditingController();
TextEditingController amostraController = TextEditingController();
TextEditingController produtoController = TextEditingController();
TextEditingController localController = TextEditingController();
TextEditingController dataController = TextEditingController();
TextEditingController sensibilidadeMaximaController = TextEditingController();
TextEditingController sensibilidadeMediaController = TextEditingController();
TextEditingController sensibilidadeMinimaController = TextEditingController();
TextEditingController tensao127Controller = TextEditingController();
TextEditingController tensao220Controller = TextEditingController();
TextEditingController temperaturaInicialController = TextEditingController();
TextEditingController temperaturaFinalController = TextEditingController();
TextEditingController umidadeInicialController = TextEditingController();
TextEditingController umidadeFinalController = TextEditingController();
TextEditingController novoProdutoController = TextEditingController();
TextEditingController maxAngleController = TextEditingController(text: '180');
TextEditingController typeOfTestController =
    TextEditingController(text: 'Angular');
TextEditingController observacaoController = TextEditingController();

bool isSmartphone = false;

final Map<String, dynamic> table = {
  // blocoNumber
  'bloco0': {
    'titles': {
      0: {2, 'RIA', riaController},
    },
    'controllers': {
      0: {riaController},
    }
  },
  'bloco1': {
    'titles': {
      // index: {flex, title}
      0: {2, 'Amostra', amostraController},
      1: {8, 'Produto', produtoController},
      2: {5, 'Local', localController},
      3: {3, 'Data', dataController},
    },
    //index: {TextEditingController}
    'controllers': {
      0: {amostraController},
      1: {produtoController},
      2: {localController},
      3: {dataController}
    }
  },
  'bloco2': {
    'titles': {
      // index: {flex, title}
      0: {3, 'Sensibilidade'},
      1: {3, 'Tensão'},
      2: {3, 'Temperatura'},
      3: {3, 'Umidade'},
    },
    'subtitles': {
      // index : {flex, title1, title2, ...}
      0: {3, 'Max', 'Med', 'Min'},
      1: {3, '127', '220'},
      2: {3, 'Inicial', 'Final'},
      3: {3, 'Inicial', 'Final'},
    },
    'controllers': {
      // index : {TextEditingController1, TextEditingController2, ...}
      0: {
        sensibilidadeMaximaController,
        sensibilidadeMediaController,
        sensibilidadeMinimaController
      },
      1: {tensao127Controller, tensao220Controller},
      2: {temperaturaInicialController, temperaturaFinalController},
      3: {umidadeInicialController, umidadeFinalController},
    },
  },
  'bloco3': {
    'titles': {
      0: {1, 'Observação'},
    },
    'controllers': {
      0: {observacaoController},
    }
  }
};
