/**
 * ����ҳ��
 */
$(function(){

    var myChart = echarts.init(document.getElementById('main'));
    option = {
        tooltip : {
            trigger: 'axis'
        },
        toolbox: {
            show : true,
            feature : {
                mark : {show: true},
                dataView : {show: true, readOnly: false},
                magicType : {show: true, type: ['line', 'bar']},
                restore : {show: true},
                saveAsImage : {show: true}
            }
        },
        calculable : true,
        xAxis : [
            {
                type : 'category',
                data : ['','','','','','','','','','','','']
            }
        ],
        yAxis : [
            {
                type : 'value'
            }
        ],
        series : [
            {
                type:'bar',
                barWidth: '40%',
                data:[2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
                itemStyle: {
                    normal: {
                        color: function(params) {
                            // build a color map as your need.
                            var colorList = [
                                '#27727B','#27727B','RED','yellow','#27727B',
                                '#27727B','#27727B','#27727B','#27727B','#27727B',
                                '#27727B','#27727B','#27727B','#27727B','#27727B'
                            ];
                            return colorList[params.dataIndex]
                        }
                    }
                }
            }
        ]
    };
    myChart.setOption(option);
});