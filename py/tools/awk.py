#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
    awk.py

    Use to generate awk scripts based on awk parameters.
    :copyright: (c) 2019 by nk.wangshuangquan@gmail.com
    :license: BSD, see LICENSE for more details.
"""


class Tool(object):
    """
    Tool class for static methods.
    """

    @staticmethod
    def sum_group_by(key_columns, value_columns, awk_args='', remain=''):
        """
        General sum group by awk script.
        :param key_columns: columns to used as key
        :param value_columns: columns to used as value
        :param awk_args: awk args such as -F'sep'
        :param remain: remain args such as input files
        :return:
        """
        # awk -F'\t' -v k0=2 -v k1=3 -v v0=1 -v v1=4 -v v2=7
        # '{k = $k0"\t"$k1; s0[k] += $v0; s1[k] += $v1; s2[k] += $v3}
        #  END { for (i in s0) { print i "\t" s0[i] "\t" s1[i] "\t" s2[i] }}'

        keys = key_columns.split()
        values = value_columns.split()

        parts = [
            'awk {} '.format(awk_args) if awk_args else 'awk'
        ]

        for (i, v) in enumerate(keys):
            parts.append('k' + str(i) + '=' + str(v))

        for (i, v) in enumerate(values):
            parts.append('v' + str(i) + '=' + str(v))

        v_part = " -v ".join(parts)

        body = '{k = ' + '"\\t"'.join(['$k{i}'.format(i=i) for i in range(len(keys))]) + "; "
        body += '; '.join(['s{i}[k] += $v{i}'.format(i=i) for i in range(len(values))])
        body += '}'

        end_part = ' END {'
        end_part += 'for (i in s0) { print i "\\t" '
        end_part += ' "\\t" '.join(['s{i}[i]'.format(i=i) for i in range(len(values))])
        end_part += '}'

        print(v_part + " '" + body + end_part + "}' " + remain)

    @staticmethod
    def column(key_columns, awk_args='', remain=''):
        """
        General sum group by awk script.
        :param key_columns: columns to used as key
        :param awk_args: awk args such as -F'sep'
        :param remain: remain args such as input files
        :return:
        """
        # awk -F'\t' -v k0=2 -v k1=3 -v v0=1 -v v1=4 -v v2=7
        # '{k = $k0"\t"$k1; s0[k] += $v0; s1[k] += $v1; s2[k] += $v3}
        #  END { for (i in s0) { print i "\t" s0[i] "\t" s1[i] "\t" s2[i] }}'

        keys = key_columns.split()

        parts = [
            'awk {} '.format(awk_args) if awk_args else 'awk'
        ]

        for (i, v) in enumerate(keys):
            parts.append('k' + str(i) + '=' + str(v))

        v_part = " -v ".join(parts)

        body = '{print ' + '"\\t"'.join(['$k{i}'.format(i=i) for i in range(len(keys))]) + ";}' "

        print(v_part + " '" + body + remain)


if __name__ == '__main__':
    Tool.sum_group_by('2 3', '1 4 7', '-F"\\x01"', 'input_file')
    Tool.column('2 3', '-F"\\x01"', 'input_file')
