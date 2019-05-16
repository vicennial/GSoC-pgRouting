/*PGR-GNU*****************************************************************

Copyright (c) 2019 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2019 Gudesa Venkata Sai Akhil
Mail: gvs.akhil1997@gmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

********************************************************************PGR-GNU*/

#ifndef INCLUDE_DUMMY_PGR_DUMMY_HPP_
#define INCLUDE_DUMMY_PGR_DUMMY_HPP_
#pragma once

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>

#if BOOST_VERSION_OK
#include <boost/graph/dijkstra_shortest_paths.hpp>
#else
#include "boost/dijkstra_shortest_paths.hpp"
#endif

#include <deque>
#include <set>
#include <vector>
#include <algorithm>
#include <sstream>
#include <functional>
#include <limits>
#include <numeric>

#include "cpp_common/basePath_SSEC.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "visitors/dijkstra_one_goal_visitor.hpp"

#if 0
#include "./../../common/src/signalhandler.h"
#endif

namespace pgrouting {

template < class G > class Pgr_dummy;
// user's functions
// for development


/* 1 to 1*/
template < class G >
Path
pgr_dummy(
        G &graph,
        int64_t source,
        int64_t target,
        bool only_cost = false) {
    Pgr_dummy< G > fn_dummy;
    return fn_dummy.dummy(graph, source, target, only_cost);
}




//******************************************

template < class G >
class Pgr_dummy {
 public:
     typedef typename G::V V;
     typedef typename G::E E;

     //! @name Dummy
     //@{
     // preparation 
     std::deque<Path> dummy(
             G &graph,
             const std::vector< int64_t > &start_vertex,
             const std::vector< int64_t > &end_vertex,
             bool only_cost,
             size_t n_goals = std::numeric_limits<size_t>::max()) {
         // a call to 1 to many is faster for each of the sources
         std::deque<Path> paths;

         int start_val = start_vertex.front(), end_val = start_vertex.end();
         if(start_val > end_val) swap(start_val, end_val);

         Path p(start_val, start_val);
         p.push_back({start_val, -1, 0, 0});
         paths.insert(p);

         std::sort(paths.begin(), paths.end(),
                 [](const Path &e1, const Path &e2)->bool {
                 return e1.end_id() < e2.end_id();
                 });
         std::stable_sort(paths.begin(), paths.end(),
                 [](const Path &e1, const Path &e2)->bool {
                 return e1.start_id() < e2.start_id();
                 });
         return paths;
     }

     //@}
   
};

}  // namespace pgrouting


#endif  // INCLUDE_DUMMY_PGR_DUMMY_HPP_
