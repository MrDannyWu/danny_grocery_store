// Grafana echarts 插件, 数据可视化通用配置

// 默认读取 A 查询 所有的字段
const a_data = data.series[0].fields;
// 默认的图表类型是bar 可选：bar, line, pie, funnel
const default_type = 'funnel';
// 左边 y 轴标签名
const y_1_name = '单位：RMB';
// 右边 y 轴标签名
const y_2_name = '百分比';
const y_1_formatter = '{value}';
const y_2_formatter = '{value} %';
var legend_data = [];
var x_axis = [];
var series = [];

// 是否展示 legend 默认：true
const legend_show = true;

// 有一些可视化组件需要的数据格式是  [{ value: 40, name: 'rose 1' }] 形式
var key_value_data_list = [];

// 遍历所有的字段(默认a)
for (var i in a_data) {
  field_data = a_data[i];
  // 判断是不是x轴的字段，
  if (Number(field_data.values[0]).toString() !== 'NaN' && field_data.type !== 'time') {

    // 对于 bar 和 line 混合图，判断为小数时，以 line 展示百分比
    if (a_data[i].name.includes('率') || a_data[i].name.includes('比')) {
      var new_data_list = [];
      // console.log(a_data[i].values);
      for (d in a_data[i].values) {
        // console.log(d);
        // console.log(a_data[i].values[d]);
        new_data_list.add(Number(a_data[i].values[d]) * 100);
      }
      // console.log(new_data_list);
      series_data = {
        name: a_data[i].name,
        type: 'line',
        yAxisIndex: 1,
        data: new_data_list,
        tooltip: {
          valueFormatter: function (value) {
            return value + ' %';
          }
        }
      };
    }
    else {
      // 生成 bar 图像所需要的数据
      series_data = {
        name: a_data[i].name,
        type: default_type,
        data: a_data[i].values
      };

    }
    series.add(series_data);
    legend_data.add(a_data[i].name);
    key_value_data_list.add({ value: a_data[i].values, name: a_data[i].name });
  }
  else {
    // 生成 x 轴数据
    x_axis = a_data[i].values;
  }

}

// Bar 和 line 的基础配置，直接拷贝 Echarts example 的 option 改一下变量即可
let bar_line_report = {
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'cross',
      crossStyle: {
        color: '#999'
      }
    }
  },
  toolbox: {
    feature: {
      dataView: { show: true, readOnly: false },
      magicType: { show: true, type: ['line', 'bar'] },
      restore: { show: true },
      saveAsImage: { show: true }
    }
  },
  legend: {
    show: legend_show,
    data: legend_data
  },
  xAxis: [
    {
      type: 'category',
      data: x_axis,
      axisPointer: {
        type: 'shadow'
      }
    }
  ],
  yAxis: [
    // 左边 Y轴
    {
      type: 'value',
      name: y_1_name,
      // min: 0,
      // max: 5000,
      // interval: 1000
      axisLabel: {
        formatter: y_1_formatter
      }
    },
    // 右边 Y轴
    {
      type: 'value',
      name: y_2_name,
      // min: 65,
      // max: 100,
      // interval: 5,
      axisLabel: {
        formatter: y_2_formatter
      }
    }
  ],
};


// Pie 的基础配置，直接拷贝 Echarts example 的 option 改一下变量即可
let pie_report = {
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    show: legend_show,
    data: legend_data
  },
  toolbox: {
    show: true,
    feature: {
      mark: { show: true },
      dataView: { show: true, readOnly: false },
      restore: { show: true },
      saveAsImage: { show: true }
    }
  },
  series: {
    // name: 'Area Mode',
    type: 'pie',
    radius: ['20%', '75%'],
    center: ['50%', '50%'],
    roseType: 'area',
    itemStyle: {
      borderRadius: 5
    }, label: {
      show: true,
      // position: 'inner',
      // fontSize: 14,
      formatter: '{b}: {c}',
    },
    data: key_value_data_list
  }
};


// Funnel 的基础配置，直接拷贝 Echarts example 的 option 改一下变量即可
let funnel_report = {
  // title: {
  //   text: 'Funnel'
  // },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c}'
  },
  toolbox: {
    feature: {
      dataView: { readOnly: false },
      restore: {},
      saveAsImage: {}
    }
  },
  legend: {
    show: legend_show,
    // type: 'scroll',
    // orient: 'vertical',
    // left: 5,
    // top: 'center',
    // bottom: 20,
    data: legend_data
  },
  series: [
    {
      name: 'Funnel',
      type: 'funnel',
      left: '10%',
      top: 60,
      bottom: 60,
      width: '80%',
      min: 0,
      // max: 100,
      minSize: '0%',
      maxSize: '100%',
      sort: 'descending',
      gap: 2,
      label: {
        show: true,
        position: 'inside',
        formatter: '{b}: {c}',
      },
      labelLine: {
        length: 10,
        lineStyle: {
          width: 1,
          type: 'solid'
        }
      },
      itemStyle: {
        borderColor: '#fff',
        borderWidth: 1
      },
      emphasis: {
        label: {
          fontSize: 20
        }
      },
      data: key_value_data_list
    }
  ]
};

if (default_type === 'pie') {
  report = pie_report;
}
else if (default_type === 'line') {
  report = bar_line_report;
  report['series'] = series;
}
else if (default_type === 'bar') {
  report = bar_line_report;
  report['series'] = series;
}
else if (default_type === 'funnel') {
  report = funnel_report;
}

return report;