classdef File < handle
    properties
        ju_file
    end
    
    properties (Access = private)
        juf_getter
    end
    
    properties (Dependent)
        detector_name
        gain_file
        pedestal_file
        conversion
        mask
        gap_pixels
        double_pixels
        geometry
        parallel
    end
    
    methods
        function obj = File(filename, options)
            
            arguments
                filename
                options.gain_file = ""
                options.pedestal_file = ""
                options.conversion = true
                options.mask = true
                options.gap_pixels = true
                options.double_pixels = "keep"
                options.geometry = true
                options.parallel = true
            end
            
            options = namedargs2cell(options);
            kwargs = pyargs(options{:});
            obj.ju_file = py.jungfrau_utils.File(filename, kwargs);
            obj.juf_getter = py.getattr(obj.ju_file, '__getitem__');
        end
        
        function value = get.detector_name(obj)
            value = string(obj.ju_file.detector_name);
        end
        
        function value = get.gain_file(obj)
            value = string(obj.ju_file.gain_file);
        end
        
        function value = get.pedestal_file(obj)
            value = string(obj.ju_file.pedestal_file);
        end
        
        function value = get.conversion(obj)
            value = obj.ju_file.conversion;
        end
        
        function set.conversion(obj, value)
            obj.ju_file.conversion = logical(value);
        end
        
        function value = get.mask(obj)
            value = obj.ju_file.mask;
        end
        
        function set.mask(obj, value)
            obj.ju_file.mask = logical(value);
        end
        
        function value = get.gap_pixels(obj)
            value = obj.ju_file.gap_pixels;
        end
        
        function set.gap_pixels(obj, value)
            obj.ju_file.gap_pixels = logical(value);
        end
        
        function value = get.double_pixels(obj)
            value = string(obj.ju_file.double_pixels);
        end
        
        function set.double_pixels(obj, value)
            obj.ju_file.double_pixels = value;
        end
        
        function value = get.geometry(obj)
            value = obj.ju_file.geometry;
        end
        
        function set.geometry(obj, value)
            obj.ju_file.geometry = logical(value);
        end
        
        function value = get.parallel(obj)
            value = obj.ju_file.parallel;
        end
        
        function set.parallel(obj, value)
            obj.ju_file.parallel = logical(value);
        end
        
        function shape = get_shape_out(obj)
            shape = obj.ju_file.get_shape_out();
        end
        
        function pixel_mask = get_pixel_mask(obj)
            pixel_mask = logical(obj.ju_file.get_pixel_mask());
        end
        
        function sref = subsref(obj, s)
            switch s.type
                case '.'
                    sref = builtin('subsref', obj, s);
                case '()'
                    if length(s.subs) > 1
                        error('File:subsref', 'Only one index/slice is currently supported')
                    end
                    subs = s.subs{:};
                    
                    if ischar(subs)
                        if strcmp(subs, ':')
                            sref = single(obj.juf_getter(py.slice(py.NoneType, py.NoneType)));
                        else
                            sref = obj.juf_getter(py.str(subs));
                        end
                        
                    elseif isnumeric(subs)
                        subs = int64(subs);
                        if length(subs) > 1
                            subs = py.list(subs);
                        end
                        sref = single(obj.juf_getter(subs));
                        
                    else
                        error('File:subsref', 'Not supported subsref data type')
                    end
                    
                case '{}'
                    error('File:subsref', 'Not supported subsref type')
            end
        end
        
        function ind = end(obj, ~, n)
            if n > 1
                error('File:subsref', 'Only one index/slice is currently supported')
            end
            shape = obj.juf_getter('data').shape;
            ind = shape{1} - 1;
        end
        
        function close(obj)
            obj.ju_file.close()
        end
    end
end

